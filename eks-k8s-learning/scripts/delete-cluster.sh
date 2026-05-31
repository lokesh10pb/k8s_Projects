#!/bin/bash
# delete-cluster.sh — Tear down the k8s-learning EKS cluster

set -e

CLUSTER_NAME="k8s-learning"
REGION="ap-south-1"

echo "⚠️  This will DELETE the EKS cluster: $CLUSTER_NAME"
echo "   All workloads, nodes, and the VPC will be removed."
echo ""
read -p "Are you sure? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "Aborted."
  exit 0
fi

echo ""
echo "🗑️  Deleting LoadBalancer services first..."
kubectl delete svc --all 2>/dev/null || true

echo ""
echo "🗑️  Deleting EKS cluster: $CLUSTER_NAME..."

eksctl delete cluster \
  --name "$CLUSTER_NAME" \
  --region "$REGION"

echo ""
echo "✅ Cluster deleted. No further AWS charges for EKS."
