# kubectl Basics — Command Reference

A practical reference of the most-used `kubectl` commands for day-to-day Kubernetes work.

---

## Cluster Info

```bash
kubectl cluster-info                   # Show cluster endpoint info
kubectl get nodes                      # List all worker nodes
kubectl get nodes -o wide              # Nodes with IP, OS, container runtime
kubectl describe node <node-name>      # Detailed node info
```

---

## Pods

```bash
kubectl get pods                       # List pods in default namespace
kubectl get pods -n kube-system        # List pods in kube-system namespace
kubectl get pods --all-namespaces      # List pods in all namespaces
kubectl get pods -o wide               # With node placement and IP
kubectl describe pod <pod-name>        # Full pod details + events
kubectl logs <pod-name>                # View pod logs
kubectl logs <pod-name> -f             # Stream logs (follow)
kubectl exec -it <pod-name> -- bash    # Shell into a running pod
kubectl delete pod <pod-name>          # Delete a pod
```

---

## Deployments

```bash
kubectl get deployments                         # List deployments
kubectl create deployment nginx --image=nginx   # Quick create
kubectl apply -f nginx-deployment.yaml          # Create from manifest
kubectl describe deployment <name>              # Deployment details
kubectl scale deployment nginx --replicas=3     # Scale up/down
kubectl rollout status deployment/nginx         # Watch rollout progress
kubectl rollout history deployment/nginx        # View revision history
kubectl rollout undo deployment/nginx           # Rollback to previous version
kubectl delete deployment nginx                 # Delete deployment
```

---

## Services

```bash
kubectl get svc                                 # List services
kubectl expose deployment nginx \
  --type=LoadBalancer --port=80                 # Expose as LoadBalancer
kubectl describe svc nginx                      # Service details
kubectl delete svc nginx                        # Delete service
```

---

## Namespaces

```bash
kubectl get namespaces                          # List namespaces
kubectl create namespace dev                    # Create a namespace
kubectl get pods -n dev                         # Pods in 'dev' namespace
kubectl config set-context --current \
  --namespace=dev                               # Switch default namespace
```

---

## ConfigMaps & Secrets

```bash
kubectl create configmap app-config \
  --from-literal=ENV=production                 # Create ConfigMap
kubectl get configmaps                          # List ConfigMaps
kubectl describe configmap app-config           # View contents

kubectl create secret generic db-secret \
  --from-literal=password=mysecret              # Create Secret
kubectl get secrets                             # List secrets
kubectl describe secret db-secret              # View secret metadata
```

---

## Apply / Delete Manifests

```bash
kubectl apply -f manifest.yaml         # Create or update resource
kubectl apply -f ./manifests/          # Apply all YAMLs in a directory
kubectl delete -f manifest.yaml        # Delete resource from manifest
kubectl diff -f manifest.yaml          # Show what would change
```

---

## Debugging

```bash
kubectl get events --sort-by=.lastTimestamp    # Recent cluster events
kubectl top nodes                              # Node CPU/memory usage
kubectl top pods                               # Pod CPU/memory usage
kubectl run debug --image=busybox -it \
  --rm --restart=Never -- sh                  # Temporary debug pod
```
