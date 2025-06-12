# Cambia a versión GREEN
kubectl config set-context --current --namespace=blue-green-demo

# Construir el JSON como objeto y escribirlo a un archivo temporal
$patch = @{ spec = @{ selector = @{ version = "blue" } } } | ConvertTo-Json -Depth 3 -Compress
$tempFile = [System.IO.Path]::GetTempFileName()
Set-Content -Path $tempFile -Value $patch -Encoding UTF8

# Aplicar el patch desde archivo
kubectl patch svc myapp-service -n blue-green-demo --type=merge --patch-file $tempFile

# Limpiar archivo temporal (opcional)
Remove-Item $tempFile

Write-Host "`n[SUCCESS] Tráfico redirigido a versión BLUE" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan

# Verificar selector
Write-Host "`n[STATUS] Selector actual:" -ForegroundColor Yellow
kubectl get svc myapp-service -o jsonpath='{.spec.selector.version}'

# Verificar endpoints
Write-Host "`n[ENDPOINTS] Tráfico actual:" -ForegroundColor Magenta
kubectl get endpoints myapp-service -o wide

# Verificar pods
Write-Host "`n[PODS BLUE] Estado:" -ForegroundColor Yellow
kubectl get pods -l version=blue -o wide