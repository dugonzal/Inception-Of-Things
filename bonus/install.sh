k3d cluster delete inception

k3d cluster create inception \
  --k3s-arg "--disable=traefik@server:0" \
  -p "80:80@loadbalancer" \
  -p "443:443@loadbalancer"

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

kubectl -n ingress-nginx wait --for=condition=Ready pod \
  -l app.kubernetes.io/component=controller --timeout=120s

helm install gitlab gitlab/gitlab \
  --create-namespace \
  --namespace gitlab \
  --set certmanager-issuer.email="admin@example.com" \
  --set global.ingress.configureCertmanager=true \
  --set ingress.tls.enabled=true

kubectl -n gitlab get secret gitlab-gitlab-initial-root-password \
  -o jsonpath="{.data.password}" | base64 --decode
echo
