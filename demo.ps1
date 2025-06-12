Write-Host "===== DEMO BLUE/GREEN DEPLOYMENT =====" -ForegroundColor Cyan

# Paso 1: Estado inicial (BLUE)
Write-Host "`n[1] INICIO - Versión BLUE activa" -ForegroundColor Yellow
kubectl patch svc myapp-service -p '{\"spec\":{\"selector\":{\"version\":\"green\"}}}' --type=merge --v=
Start-Sleep 2
kubectl get endpoints myapp-service

# Paso 2: Cambio a GREEN
Write-Host "`n[2] CAMBIO - Activando versión GREEN" -ForegroundColor Yellow
kubectl set selector svc myapp-service version=green
Start-Sleep 2
kubectl get endpoints myapp-service

# Paso 3: Rollback a BLUE
Write-Host "`n[3] ROLLBACK - Volviendo a versión BLUE" -ForegroundColor Yellow
kubectl patch svc myapp-service -p '{\"spec\":{\"selector\":{\"version\":\"blue\"}}}' --type=merge --v=0
Start-Sleep 2
kubectl get endpoints myapp-service

Write-Host "`n¡Demo completada con éxito!" -ForegroundColor Green