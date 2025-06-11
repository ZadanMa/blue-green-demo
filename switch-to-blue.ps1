# Cambia a versión BLUE
kubectl patch svc myapp-service -p '{\"spec\":{\"selector\":{\"version\":\"blue\"}}}' --type=merge --v=0

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