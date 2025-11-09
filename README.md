# Twitter Clone - DevOps Project

Full-stack Twitter Clone application deployed on Kubernetes using Helm charts.

## 🏗️ Architecture

- **Frontend**: React + Vite + Nginx
- **Backend**: FastAPI + SQLAlchemy
- **Database**: PostgreSQL 16
- **Orchestration**: Kubernetes (Kind)
- **Package Manager**: Helm 3

## 📁 Project Structure
```
├── ansible/              # Configuration management
├── terraform/            # Infrastructure as Code
├── kind/                 # Kind cluster configuration
├── helm/
│   └── twitter-clone/   # Umbrella Helm chart
│       ├── Chart.yaml
│       ├── values.yaml
│       └── charts/      # Dependencies (PostgreSQL, backend, frontend)
└── docker-compose.yml   # Local development
```

## 🚀 Quick Start

### Prerequisites

- Docker 28.5+
- Kind v0.30.0
- Helm v3.17+
- kubectl

### Deploy to Kind
```bash
# Create Kind cluster
kind create cluster --config kind/kind-config.yaml

# Deploy application
cd helm/twitter-clone
helm dependency update
helm install twitter-clone . \
  --namespace default \
  --create-namespace \
  --wait

# Access application
kubectl port-forward -n default svc/twitter-clone-frontend 3000:80
```

Visit: http://localhost:3000

## 📦 Components

### Backend Chart
Located in `devops_backend/chart/`
- FastAPI REST API
- PostgreSQL connection
- Health checks

### Frontend Chart  
Located in `devops_frontend/chart/`
- React SPA
- Nginx reverse proxy
- API routing

### Umbrella Chart
Located in `helm/twitter-clone/`
- PostgreSQL (Bitnami)
- Backend (local dependency)
- Frontend (local dependency)

## 🛠️ Development

### Build Images
```bash
# Backend
cd devops_backend
make build
make load-kind

# Frontend
cd devops_frontend
make build
make load-kind
```

### Update Deployment
```bash
cd helm/twitter-clone
helm upgrade twitter-clone . --namespace default
```

## 📊 Monitoring
```bash
# Check pods
kubectl get pods -A

# View logs
kubectl logs -n default -l app.kubernetes.io/name=backend
kubectl logs -n default -l app.kubernetes.io/name=frontend

# Check PostgreSQL
kubectl exec -n database twitter-clone-postgresql-0 -- psql -U postgres -d twitter_clone
```

## 🧹 Cleanup
```bash
# Uninstall application
helm uninstall twitter-clone --namespace default

# Delete Kind cluster
kind delete cluster --name devops-cluster
```

## 📝 Author

**hereWeGo**
