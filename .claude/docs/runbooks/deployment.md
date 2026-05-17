# Runbook: Deployment

Step-by-step deployment procedure for production.

## Pre-Deployment

### 1. Code Ready
- [ ] All tests passing in CI
- [ ] PR reviewed and approved
- [ ] Security review completed (for new endpoints)
- [ ] Performance impact assessed

### 2. Database Migration Ready
```powershell
# Generate SQL migration script
dotnet ef migrations script {PreviousMigration} {NewMigration} `
  --project src/Infrastructure `
  --startup-project src/WebApi `
  --output deploy/migration-{date}.sql `
  --idempotent

# Test on staging DB first
# Review the generated SQL before production
```

### 3. Configuration
- [ ] New app settings added to Azure Key Vault
- [ ] Connection strings verified for environment
- [ ] Feature flags configured

---

## Deployment Steps

### Step 1: Deploy Database Migration
```bash
# Apply migration to production DB
dotnet ef database update {NewMigration} \
  --project src/Infrastructure \
  --startup-project src/WebApi \
  --connection "{prod-connection-string}"

# Verify migration applied
SELECT TOP 1 MigrationId FROM __EFMigrationsHistory ORDER BY MigrationId DESC
```

### Step 2: Deploy Backend API
```bash
# AKS rolling update
kubectl set image deployment/{app-name} \
  {container}={acr-name}.azurecr.io/{image}:{tag} \
  -n {namespace}

# Watch rollout
kubectl rollout status deployment/{app-name} -n {namespace}

# Verify health
curl https://{api-url}/health
```

### Step 3: Deploy Angular Frontend
```bash
# Build production bundle
ng build --configuration production

# Deploy to Azure Static Web Apps
az staticwebapp deploy \
  --app-name {app-name} \
  --source dist/{app-name}/browser
```

### Step 4: Smoke Tests
```bash
# Health check
curl -f https://{api-url}/health || echo "HEALTH CHECK FAILED"

# Critical endpoint test
curl -f https://{api-url}/api/v1/{resource} \
  -H "Authorization: Bearer {test-token}" \
  || echo "API CHECK FAILED"
```

### Step 5: Monitor (First 30 minutes)
- [ ] Application Insights — error rate < 1%
- [ ] Application Insights — response time < SLA
- [ ] Azure SQL / PostgreSQL — CPU < 70%
- [ ] Redis — hit rate > 80%
- [ ] AKS pod restarts = 0

---

## Rollback

### If Backend Fails
```bash
# Rollback K8s deployment
kubectl rollout undo deployment/{app-name} -n {namespace}
kubectl rollout status deployment/{app-name} -n {namespace}
```

### If Migration Fails
```bash
# Check what migration is applied
SELECT TOP 5 MigrationId FROM __EFMigrationsHistory ORDER BY MigrationId DESC

# Rollback to previous
dotnet ef database update {PreviousMigration} \
  --connection "{prod-connection-string}"
```

### If Frontend Fails
```bash
# Azure Static Web Apps — redeploy previous build
# Go to Azure Portal → Static Web Apps → Deployments → Previous → Redeploy
```

---

## Post-Deployment

- [ ] Deployment logged in team channel
- [ ] CHANGELOG entry verified
- [ ] Monitoring dashboard bookmarked for next 24h
- [ ] On-call notified of deployment

## Contacts During Deployment
- On-call engineer: [name / PagerDuty]
- DBA on-call: [name]
- Azure support: [portal link]
