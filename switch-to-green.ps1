# Cambia a versión GREEN
kubectl config set-context --current --namespace=blue-green-demo

# 1. Captura el tiempo de inicio
$startTime = Get-Date
Write-Host "[INFO] Iniciando cambio a versión GREEN..." -ForegroundColor Cyan

# Construir el JSON como objeto y escribirlo a un archivo temporal
$patch = @{ spec = @{ selector = @{ version = "green" } } } | ConvertTo-Json -Depth 3 -Compress
$tempFile = [System.IO.Path]::GetTempFileName()
Set-Content -Path $tempFile -Value $patch -Encoding UTF8

# 2. Aplicar el patch desde archivo
kubectl patch svc myapp-service -n blue-green-demo --type=merge --patch-file $tempFile

# 3. Esperar hasta que los endpoints reflejen la nueva versión
Write-Host "[INFO] Esperando actualización de endpoints..." -ForegroundColor Cyan
$timeout = 30  # segundos
$elapsed = 0
while ($true) {
    $endpoints = kubectl get endpoints myapp-service -n blue-green-demo -o jsonpath='{.subsets[*].addresses[*].targetRef.name}'
    if ($endpoints -match "myapp-green") { break }
    Start-Sleep -Seconds 1
    $elapsed += 1
    if ($elapsed -ge $timeout) {
        Write-Host "[ERROR] Timeout esperando actualización de endpoints" -ForegroundColor Red
        exit 1
    }
}

# 4. Calcular duración total
$endTime = Get-Date
$duration = ($endTime - $startTime).TotalSeconds

# Limpiar archivo temporal (opcional)
Remove-Item $tempFile

# Resultado final
Write-Host "`n[SUCCESS] Tráfico redirigido a versión GREEN" -ForegroundColor Green
Write-Host "Tiempo de cambio: $([math]::Round($duration, 2)) segundos" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Cyan

# Verificar selector
Write-Host "`n[STATUS] Selector actual:" -ForegroundColor Yellow
kubectl get svc myapp-service -o jsonpath='{.spec.selector.version}'

# Verificar endpoints
Write-Host "`n[ENDPOINTS] Tráfico actual:" -ForegroundColor Magenta
kubectl get endpoints myapp-service -o wide

# Verificar pods
Write-Host "`n[PODS GREEN] Estado:" -ForegroundColor Yellow
kubectl get pods -l version=green -o wide