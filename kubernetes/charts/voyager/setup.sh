
#!/bin/bash
#  Copyright 2017, 2018, Oracle Corporation and/or affiliates.  All rights reserved.

# Install Utility onessl 
which onessl
if test $? != 0; then
  curl -fsSL -o onessl https://github.com/kubepack/onessl/releases/download/0.3.0/onessl-linux-amd64 \
    && chmod +x onessl \
    && mv onessl ~/bin
fi

# Add Appscode Chart Repository
if test "$(helm search appscode/voyager | grep voyager |  wc -l)" = 0; then
  helm repo add appscode https://charts.appscode.com/stable/
  helm repo update
  helm search appscode/voyager
fi

# Install Voyager to K8S 1.9.x - 1.10.x
if test "$(kubectl get ns | grep voyager |  wc -l)" = 0; then
  kubectl create ns voyager
  helm install appscode/voyager --name voyager-operator --version 7.4.0 \
    --namespace voyager \
    --set cloudProvider=baremetal \
    --set apiserver.ca="$(onessl get kube-ca)" \
    --set apiserver.enableValidatingWebhook=true
fi

# Install Voyager Ingress
if test "$(kubectl get ingresses.voyager.appscode.com | grep path-routing | wc -l)" = 0; then
  kubectl create -f samples/path-routing.yaml
fi
if test "$(kubectl get ingresses.voyager.appscode.com | grep host-routing | wc -l)" = 0; then
  kubectl create -f samples/host-routing.yaml
fi

