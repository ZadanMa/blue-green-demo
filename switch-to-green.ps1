# Cambia a versión GREEN
kubectl patch svc myapp-service -p '{\"spec\":{\"selector\":{\"version\":\"green\"}}}' --type=merge --v=0

Write-Host "`n[SUCCESS] Tráfico redirigido a versión GREEN" -ForegroundColor Green
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