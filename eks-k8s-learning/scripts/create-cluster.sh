#!/bin/bash
# create-cluster.sh — Provision the k8s-learning EKS cluster

set -e

CLUSTER_NAME="k8s-learning"
REGION="ap-south-1"
NODE_TYPE="t3.medium"
NODES=2
NODES_MIN=1
NODES_MAX=3

echo "🚀 Creating EKS cluster: $CLUSTER_NAME in $REGION..."
echo "   Node type : $NODE_TYPE"
echo "   Nodes     : $NODES (min: $NODES_MIN, max: $NODES_MAX)"
echo ""

eksctl create cluster \
  --name "$CLUSTER_NAME" \
  --region "$REGION" \
  --nodegroup-name workers \
  --node-type "$NODE_TYPE" \
  --nodes "$NODES" \
  --nodes-min "$NODES_MIN" \
  --nodes-max "$NODES_MAX" \
  --managed

echo ""
echo "✅ Cluster ready! Updating kubeconfig..."

aws eks update-kubeconfig \
  --region "$REGION" \
  --name "$CLUSTER_NAME"

echo ""
echo "✅ Done! Run 'kubectl get nodes' to verify."
