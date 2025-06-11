# demo.ps1
Clear-Host
Write-Host "`n===== DEMOSTRACIÓN BLUE/GREEN DEPLOYMENT =====" -ForegroundColor White -BackgroundColor DarkBlue
Write-Host "==============================================" -ForegroundColor Cyan

# Paso 1: Estado inicial (BLUE)
Write-Host "`n[PASO 1] Estado inicial (BLUE)" -ForegroundColor Yellow
.\switch-to-blue.ps1

# Esperar y mostrar tráfico
Start-Sleep -Seconds 2
Write-Host "`n[MONITOR] Verificando tráfico a pods BLUE..." -ForegroundColor Magenta
kubectl get endpoints myapp-service -o wide

# Paso 2: Cambio a GREEN
Write-Host "`n`n[PASO 2] Cambio a versión GREEN" -ForegroundColor Yellow
.\switch-to-green.ps1

# Esperar y mostrar tráfico
Start-Sleep -Seconds 2
Write-Host "`n[MONITOR] Verificando tráfico a pods GREEN..." -ForegroundColor Magenta
kubectl get endpoints myapp-service -o wide

# Paso 3: Rollback a BLUE
Write-Host "`n`n[PASO 3] Rollback a versión BLUE" -ForegroundColor Yellow
.\switch-to-blue.ps1

# Resultado final
Write-Host "`n`n[RESULTADO] ¡Demostración completada con éxito!" -ForegroundColor Green -BackgroundColor Black
Write-Host "================================================" -ForegroundColor Green