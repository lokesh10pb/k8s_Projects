# ☸️ Amazon EKS — Kubernetes Learning Lab

> A hands-on project documenting my journey learning Kubernetes on AWS EKS. This repository contains cluster setup guides, kubectl commands, Kubernetes manifests, and notes built while practising real-world k8s concepts.

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white)
![AWS EKS](https://img.shields.io/badge/AWS_EKS-FF9900?style=flat&logo=amazonaws&logoColor=white)
![eksctl](https://img.shields.io/badge/eksctl-v0.180+-blue?style=flat)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=flat)

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Tech Stack](#-tech-stack)
- [Prerequisites](#-prerequisites)
- [Cluster Setup](#-cluster-setup)
- [Connecting kubectl](#-connecting-kubectl)
- [Deploy Your First App](#-deploy-your-first-app)
- [Project Structure](#-project-structure)
- [Key Concepts Covered](#-key-concepts-covered)
- [Cost Management](#-cost-management)
- [Cleanup](#-cleanup)
- [Resources](#-resources)

---

## 🎯 Project Overview

This project documents setting up and using an Amazon EKS (Elastic Kubernetes Service) cluster for learning Kubernetes from the ground up. The goal is to practice real-world Kubernetes workflows that are used in production DevOps and Cloud Engineering roles.

**What this project covers:**
- Provisioning a managed EKS cluster using `eksctl`
- Deploying and managing workloads with `kubectl`
- Writing and applying Kubernetes manifests (YAML)
- Understanding core k8s objects: Pods, Deployments, Services, ConfigMaps, Secrets
- Hands-on experience with AWS networking (VPC, subnets, IAM roles)

---

## 🛠 Tech Stack

| Tool | Purpose | Version |
|------|---------|---------|
| Amazon EKS | Managed Kubernetes control plane | 1.29+ |
| eksctl | CLI to provision EKS clusters | v0.180+ |
| kubectl | Kubernetes CLI to manage workloads | v1.29+ |
| AWS CLI | AWS resource management | v2.x |
| AWS EC2 (t3.medium) | Worker nodes | — |

---

## ✅ Prerequisites

Install the following tools before getting started:

### 1. AWS CLI
```bash
# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

# Verify
aws --version
```

### 2. eksctl
```bash
# macOS
brew tap weaveworks/tap
brew install weaveworks/tap/eksctl

# Linux
curl --silent --location "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Verify
eksctl version
```

### 3. kubectl
```bash
# macOS
brew install kubectl

# Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verify
kubectl version --client
```

### 4. Configure AWS Credentials
```bash
aws configure
# AWS Access Key ID: <your-key>
# AWS Secret Access Key: <your-secret>
# Default region name: ap-south-1
# Default output format: json
```

---

## 🚀 Cluster Setup

Create the EKS cluster using `eksctl`. This single command provisions:
- A managed EKS control plane
- VPC with public/private subnets
- IAM roles and node groups
- 2 worker nodes (auto-scaling: 1–3)

```bash
eksctl create cluster \
  --name k8s-learning \
  --region ap-south-1 \
  --nodegroup-name workers \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed
```

> ⏱️ **Note:** Cluster creation takes approximately **15–20 minutes**. eksctl will stream progress to your terminal.

**Expected output on success:**
```
✅  EKS cluster "k8s-learning" in "ap-south-1" region is ready
```

---

## 🔗 Connecting kubectl

After the cluster is ready, configure `kubectl` to point to it:

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name k8s-learning
```

**Verify the connection:**
```bash
# List worker nodes
kubectl get nodes

# Expected output:
# NAME                                        STATUS   ROLES    AGE   VERSION
# ip-192-168-x-x.ap-south-1.compute.internal   Ready    <none>   5m    v1.29.x
# ip-192-168-x-x.ap-south-1.compute.internal   Ready    <none>   5m    v1.29.x

# List all running pods across namespaces
kubectl get pods --all-namespaces
```

---

## 🌐 Deploy Your First App

Deploy a simple nginx web server to test the cluster end-to-end:

```bash
# Create a Deployment
kubectl create deployment nginx --image=nginx

# Expose it via a LoadBalancer Service
kubectl expose deployment nginx \
  --type=LoadBalancer \
  --port=80

# Watch the Pod come up (Ctrl+C to stop watching)
kubectl get pods -w

# Get the external LoadBalancer URL (takes ~2 min to provision)
kubectl get svc nginx
```

Once `EXTERNAL-IP` shows an address, open it in your browser to see nginx running on your EKS cluster.

---

## 📁 Project Structure

```
eks-k8s-learning/
│
├── README.md                    # This file
│
├── docs/
│   ├── 01-cluster-setup.md      # Detailed cluster provisioning notes
│   ├── 02-kubectl-basics.md     # Essential kubectl commands reference
│   ├── 03-pods-deployments.md   # Pods and Deployments deep dive
│   ├── 04-services.md           # Services: ClusterIP, NodePort, LoadBalancer
│   └── 05-configmaps-secrets.md # ConfigMaps and Secrets usage
│
├── manifests/
│   └── examples/
│       ├── nginx-deployment.yaml    # Sample Deployment manifest
│       ├── nginx-service.yaml       # Sample Service manifest
│       └── configmap-example.yaml   # Sample ConfigMap manifest
│
└── scripts/
    ├── create-cluster.sh        # One-command cluster creation
    └── delete-cluster.sh        # One-command cluster teardown
```

---

## 📚 Key Concepts Covered

| Concept | Description |
|---------|-------------|
| **Pod** | Smallest deployable unit in Kubernetes; wraps one or more containers |
| **Deployment** | Manages a set of identical Pods; handles rolling updates and rollbacks |
| **Service** | Stable network endpoint that routes traffic to Pods |
| **ConfigMap** | Stores non-sensitive configuration as key-value pairs |
| **Secret** | Stores sensitive data (passwords, tokens) in base64-encoded form |
| **Node Group** | Set of EC2 instances that run as worker nodes |
| **Namespace** | Virtual cluster for resource isolation within a cluster |
| **kubectl** | CLI for interacting with the Kubernetes API server |

---

## 💰 Cost Management

> ⚠️ **Important:** EKS costs money. Always delete the cluster when not actively learning.

| Resource | Approximate Cost |
|----------|-----------------|
| EKS Control Plane | ~$0.10/hour (~$72/month) |
| 2x t3.medium nodes | ~$0.083/hour each (~$60/month each) |
| Load Balancer | ~$0.025/hour |
| **Total (running 24/7)** | **~$200/month** |

**Cost-saving tip:** Only spin up the cluster when actively learning. Each session costs ~$0.30–0.50/hour total.

---

## 🗑️ Cleanup

Delete all resources when done to avoid charges:

```bash
# Delete any LoadBalancer services first (frees the AWS ELB)
kubectl delete svc nginx

# Delete the entire cluster (VPC, nodes, IAM roles, everything)
eksctl delete cluster \
  --name k8s-learning \
  --region ap-south-1
```

> ⏱️ Deletion takes approximately **10–15 minutes**.

---

## 📖 Resources

- [Kubernetes Official Docs](https://kubernetes.io/docs/home/)
- [Amazon EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
- [eksctl Documentation](https://eksctl.io/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [AWS Free Tier Info](https://aws.amazon.com/free/)

---

## 👤 Author

**Your Name**
- LinkedIn: [linkedin.com/in/yourprofile](https://linkedin.com/in/yourprofile)
- GitHub: [github.com/yourusername](https://github.com/yourusername)

---

> 🌱 *This is a learning project. Notes and manifests are updated as I explore more Kubernetes concepts.*
