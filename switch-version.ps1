param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("blue", "green")]
    [string]$targetVersion
)

# Crear JSON para el patch
$patchJson = @"
{"spec":{"selector":{"version":"$targetVersion"}}
"@

# Aplicar cambio
kubectl patch svc myapp-service -p $patchJson

Write-Host "`n[SUCCESS] Tráfico redirigido a versión $($targetVersion.ToUpper())" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan

# Verificar cambio
Write-Host "`n[STATUS] Selector actual del servicio:" -ForegroundColor Yellow
$selector = kubectl get svc myapp-service -o jsonpath='{.spec.selector}'
$selector | ConvertFrom-Json | Format-Table

# Monitoreo
Write-Host "`n[PODS $($targetVersion.ToUpper())] Estado actual:" -ForegroundColor Yellow
kubectl get pods -l version=$targetVersion -o wide