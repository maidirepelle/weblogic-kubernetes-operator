# Voyager Helm Chart
Official Voyager installation document: https://appscode.com/products/voyager/7.4.0/setup/install/.

## Install Steps
As a demonstration, following are the steps to install Voyager helm chart in hostlinux.

### 1. Install Utility onessl
```
# download onessl binary from https://github.com/kubepack/onessl/releases/tag/0.3.0
$ curl -fsSL -o onessl https://github.com/kubepack/onessl/releases/download/0.3.0/onessl-linux-amd64 \
  && chmod +x onessl \
  && mv onessl ~/bin
```

### 2. Add Appscode Chart Repository
```
$ helm repo add appscode https://charts.appscode.com/stable/
$ helm repo update
$ helm search appscode/voyager
```

### 3. Install Voyager to K8S
```
# Kubernetes 1.9.x - 1.10.x
$ kubectl create ns voyager
$ helm install appscode/voyager --name voyager-operator --version 7.4.0 \
  --namespace voyager \
  --set cloudProvider=baremetal \
  --set apiserver.ca="$(onessl get kube-ca)" \
  --set apiserver.enableValidatingWebhook=true
```

### 4. Install two WLS Domains
```
$ charts/create.sh domain1
$ charts/create.sh domain2
```
### 5. Install Voyager Ingress
```
$ kubectl create -f samples/path-routing.yaml
$ kubectl create -f samples/host-routing.yaml
```

### 6. Change WLS Domains and Voyager Ingress Dynamically
TBD

## Tips
### Download Voyager Helm Chart locally
You can download voyager helm chart and untar it to a local folder.
```
$ helm fetch appscode/voyager --untar --version 7.4.0
```
