#!/bin/bash
set -e

EKS_DIR="eks"
K8S_DIR="k8s"
WORDPRESS_LABEL="app=wordpress"

echo "Initializing Terraform in $EKS_DIR..."
cd $EKS_DIR
terraform init

echo "Applying Terraform configuration for EKS and RDS..."
terraform apply -auto-approve

echo "Fetching EKS cluster name and endpoint..."
CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
CLUSTER_ENDPOINT=$(terraform output -raw eks_cluster_endpoint)

echo "Waiting for EKS cluster to be ready..."
aws eks wait cluster-active --name "$CLUSTER_NAME"

echo "Updating kubeconfig for EKS cluster access..."
aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$(terraform output -raw region)"

echo "Testing Kubernetes connectivity..."
kubectl cluster-info

echo "Deploying WordPress application to EKS..."
kubectl apply -f ../$K8S_DIR/wordpress-deployment.yaml
kubectl apply -f ../$K8S_DIR/wordpress-service.yaml

echo "Waiting for WordPress service to be ready..."
kubectl wait --for=condition=available deployment -l $WORDPRESS_LABEL --timeout=300s

# Get External IP for WordPress service
echo "Fetching WordPress service external IP..."
WORDPRESS_IP=""
while [ -z "$WORDPRESS_IP" ]; do
  echo "Waiting for external IP..."
  WORDPRESS_IP=$(kubectl get svc wordpress -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
  [ -z "$WORDPRESS_IP" ] && sleep 5
done
echo "WordPress is available at http://$WORDPRESS_IP"

# Test the WordPress endpoint
echo "Running endpoint test on WordPress service..."
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" "http://$WORDPRESS_IP")
if [ "$HTTP_STATUS" -eq 200 ]; then
  echo "WordPress is successfully deployed and reachable at http://$WORDPRESS_IP"
else
  echo "Failed to reach WordPress at http://$WORDPRESS_IP. Status code: $HTTP_STATUS"
  exit 1
fi

echo "Running post deployement verification tests..."
cd ../tests
go test -v ./...

echo "Deployment and tests script completed!"
