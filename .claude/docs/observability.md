# Observability

OpenTelemetry setup, structured logging, và Application Insights cho production .NET services.

---

## Three Pillars

| Pillar | Tool | Dùng cho |
|--------|------|---------|
| **Traces** | OpenTelemetry + OTLP | Request flow qua services, DB calls, HTTP calls |
| **Metrics** | OpenTelemetry + Prometheus / Azure Monitor | Throughput, error rate, latency, custom KPIs |
| **Logs** | Serilog + OTel Logs | Structured events, exceptions, audit trail |

---

## Setup — NuGet Packages

```xml
<!-- Core OTel -->
<PackageReference Include="OpenTelemetry.Extensions.Hosting"           Version="1.*" />
<PackageReference Include="OpenTelemetry.Instrumentation.AspNetCore"   Version="1.*" />
<PackageReference Include="OpenTelemetry.Instrumentation.Http"         Version="1.*" />
<PackageReference Include="OpenTelemetry.Instrumentation.SqlClient"    Version="1.*" />
<PackageReference Include="OpenTelemetry.Exporter.OpenTelemetryProtocol" Version="1.*" />

<!-- Azure Monitor (Application Insights) -->
<PackageReference Include="Azure.Monitor.OpenTelemetry.AspNetCore"     Version="1.*" />

<!-- Serilog -->
<PackageReference Include="Serilog.AspNetCore"                         Version="8.*" />
<PackageReference Include="Serilog.Enrichers.Environment"              Version="2.*" />
<PackageReference Include="Serilog.Enrichers.Thread"                   Version="3.*" />
<PackageReference Include="Serilog.Sinks.OpenTelemetry"               Version="4.*" />
```

---

## Program.cs — Full OTel Setup

```csharp
// Traces + Metrics
builder.Services.AddOpenTelemetry()
    .ConfigureResource(r => r
        .AddService(
            serviceName:    builder.Configuration["Otel:ServiceName"]!,
            serviceVersion: Assembly.GetExecutingAssembly().GetName().Version?.ToString()))
    .WithTracing(t => t
        .AddAspNetCoreInstrumentation(o =>
        {
            o.Filter = ctx => !ctx.Request.Path.StartsWithSegments("/health")
                           && !ctx.Request.Path.StartsWithSegments("/alive");
            o.RecordException = true;
            o.EnrichWithHttpRequest = (activity, req) =>
                activity.SetTag("http.client_ip", req.HttpContext.Connection.RemoteIpAddress);
        })
        .AddHttpClientInstrumentation(o => o.RecordException = true)
        .AddSqlClientInstrumentation(o =>
        {
            // true only in non-production — SQL may contain PII
            o.SetDbStatementForText = !builder.Environment.IsProduction();
        })
        .AddEntityFrameworkCoreInstrumentation(o =>
            o.SetDbStatementForText = !builder.Environment.IsProduction())
        .AddSource("YourApp.*")
        .AddOtlpExporter(o =>
            o.Endpoint = new Uri(builder.Configuration["Otel:Endpoint"]!)))
    .WithMetrics(m => m
        .AddAspNetCoreInstrumentation()
        .AddHttpClientInstrumentation()
        .AddRuntimeInstrumentation()
        .AddMeter("YourApp.*")
        .AddOtlpExporter());

// Azure Application Insights (thay OTLP nếu dùng Azure)
// builder.Services.AddOpenTelemetry().UseAzureMonitor(o =>
//     o.ConnectionString = builder.Configuration["ApplicationInsights:ConnectionString"]);
```

---

## Serilog — Structured Logging

```csharp
// Program.cs
builder.Host.UseSerilog((ctx, lc) => lc
    .ReadFrom.Configuration(ctx.Configuration)
    .Enrich.FromLogContext()
    .Enrich.WithMachineName()
    .Enrich.WithThreadId()
    .Enrich.WithProperty("Environment", ctx.HostingEnvironment.EnvironmentName)
    .WriteTo.Console(
        ctx.HostingEnvironment.IsDevelopment()
            ? new ExpressionTemplate("[{@t:HH:mm:ss} {@l:u3}] [{SourceContext}] {@m}\n{@x}")
            : new JsonFormatter())          // JSON on production for log aggregators
    .WriteTo.OpenTelemetry());              // forward to OTel collector
```

```json
// appsettings.json
{
  "Serilog": {
    "MinimumLevel": {
      "Default": "Information",
      "Override": {
        "Microsoft.EntityFrameworkCore.Database.Command": "Warning",
        "Microsoft.AspNetCore.Hosting": "Warning",
        "Microsoft.AspNetCore.Mvc": "Warning",
        "System.Net.Http.HttpClient": "Warning"
      }
    }
  },
  "Otel": {
    "ServiceName": "YourApp.Api",
    "Endpoint": "http://localhost:4317"
  }
}
```

---

## Custom ActivitySource — Business Spans

```csharp
// src/YourApp.Application/Observability/AppActivity.cs
public static class AppActivity
{
    /// <summary>Application-level ActivitySource — register with AddSource("YourApp.*").</summary>
    public static readonly ActivitySource Source = new("YourApp.Application", "1.0.0");

    /// <summary>Start a named span for a business operation.</summary>
    public static Activity? StartOperation(string name, ActivityKind kind = ActivityKind.Internal)
        => Source.StartActivity(name, kind);
}

// Usage in handler
public async Task<Result<Guid>> Handle(CreateOrderCommand cmd, CancellationToken ct)
{
    using var span = AppActivity.StartOperation("Order.Create");
    span?.SetTag("order.customer_id", cmd.CustomerId.ToString());

    try
    {
        var order = Order.Create(cmd.CustomerId, cmd.Note);
        _repo.Add(order);
        await _uow.CommitAsync(ct);

        span?.SetTag("order.id", order.Id.ToString());
        span?.SetStatus(ActivityStatusCode.Ok);
        return Result.Success(order.Id);
    }
    catch (Exception ex)
    {
        span?.SetStatus(ActivityStatusCode.Error, ex.Message);
        span?.RecordException(ex);
        throw;
    }
}
```

---

## Custom Metrics

```csharp
// src/YourApp.Application/Observability/AppMetrics.cs
public sealed class AppMetrics
{
    private readonly Counter<long>     _ordersCreated;
    private readonly Counter<long>     _ordersFailed;
    private readonly Histogram<double> _processingMs;
    private readonly ObservableGauge<int> _activeOrders;

    public AppMetrics(IMeterFactory meterFactory, IOrderRepository repo)
    {
        var meter = meterFactory.Create("YourApp.Application", "1.0.0");

        _ordersCreated = meter.CreateCounter<long>(
            "orders.created.total", description: "Total orders successfully created");

        _ordersFailed = meter.CreateCounter<long>(
            "orders.failed.total", description: "Total order creation failures");

        _processingMs = meter.CreateHistogram<double>(
            "orders.processing.milliseconds",
            unit: "ms",
            description: "Order processing duration");

        // Gauge: reads current value on-demand
        meter.CreateObservableGauge<int>(
            "orders.pending.count",
            () => repo.GetPendingCountAsync().GetAwaiter().GetResult(),
            description: "Current pending orders in queue");
    }

    /// <summary>Record a successfully created order.</summary>
    public void RecordOrderCreated(string region)
        => _ordersCreated.Add(1, new TagList { { "region", region } });

    /// <summary>Record a failed order creation with reason.</summary>
    public void RecordOrderFailed(string reason)
        => _ordersFailed.Add(1, new TagList { { "reason", reason } });

    /// <summary>Record order processing duration in milliseconds.</summary>
    public void RecordProcessingTime(double ms)
        => _processingMs.Record(ms);
}

// Register: builder.Services.AddSingleton<AppMetrics>();
```

---

## Log Level Guide

| Level | Khi nào dùng | Ví dụ |
|-------|-------------|-------|
| `Critical` | App crash, không thể recover | DB connection hoàn toàn mất |
| `Error` | Exception ảnh hưởng request / data loss | Payment failed, unhandled exception |
| `Warning` | Recoverable issue, circuit open, slow query | Retry attempt, fallback used |
| `Information` | Business events quan trọng | Order created, user logged in |
| `Debug` | Dev detail — tắt trên prod | Cache hit/miss, query params |
| `Trace` | Framework noise — không bật bao giờ | EF Core internal operations |

---

## Không bao giờ log

```csharp
// ❌ Sensitive data
_logger.LogInformation("User password: {Password}", request.Password);
_logger.LogDebug("Token: {Token}", bearerToken);
_logger.LogError("CC: {Card}", creditCardNumber);

// ✅ Chỉ log non-sensitive identifiers
_logger.LogInformation("Order {OrderId} created for customer {CustomerId}", order.Id, cmd.CustomerId);
```

---

## Local Development — Jaeger

```bash
# Chạy Jaeger local để xem traces
docker run -d --name jaeger `
  -p 16686:16686 `   # UI
  -p 4317:4317 `     # OTLP gRPC
  jaegertracing/all-in-one:latest

# Mở: http://localhost:16686
```

---

## Azure Application Insights — Production

```csharp
// appsettings.Production.json (connection string từ Key Vault)
{
  "ApplicationInsights": {
    "ConnectionString": "InstrumentationKey=...;IngestionEndpoint=..."
  }
}

// Program.cs
builder.Services.AddOpenTelemetry().UseAzureMonitor(o =>
    o.ConnectionString = builder.Configuration["ApplicationInsights:ConnectionString"]);
```

**KQL Queries hữu ích:**
```kql
// Failed requests trong 1 giờ qua
requests | where timestamp > ago(1h) and success == false
| summarize count() by resultCode, name

// Slow operations > 1s
dependencies | where duration > 1000
| summarize avg(duration), count() by name, type | order by avg_duration desc

// Exception rate by type
exceptions | where timestamp > ago(1h)
| summarize count() by type | order by count_ desc
```
