# Install and Configure Traefik with Helm Chart
Traefik helm chart is in official Charts of Helm: https://github.com/helm/charts/tree/master/stable/traefik.

## Install Traefik Operator
The chart is in the default repository for Helm which is located at https://kubernetes-charts.storage.googleapis.com/ and is installed by default.

To install Traefik operator to namespace `traefik` with default settings:
```
helm install --name traefik-operator --namespace traefik stable/traefik
```
Or with a given values.yaml:
```
helm install --name traefik-operator --namespace traefik --values values.yaml stable/traefik
```

## Configure Traefik as Load Balancer for WLS Domains
This chapter we'll demonstrate how to use Traefik to handle traffic to backend WLS domains.

### 1. Install some WLS Domains
Now we need to prepare some backends for Traefik to do load balancer. 

Create two WLS domains: 
- One domain with name 'domain1' under namespace 'default'.
- One domain with name 'domain2' under namespace 'test1'.
- Each domain has a webapp installed with url context 'testwebapp'.

Note: After all WLS domains are running, for now we need to stop WLS operator and remove the per-domain Ingresses created by WLS operator. Otherwise the WLS operator keeps monitor the Ingresses and restore them to the original version if they are changed.

### 2. Install Ingress
#### Install Host-routing Ingress
```
$ kubectl create -f samples/host-routing.yaml
```
Now you can send request to different WLS domains with the unique entry point of Traefik.
```
$ curl --silent -H 'host: domain1.org' http://${HOSTNAME}:30301/testwebapp/
$ curl --silent -H 'host: domain2.org' http://${HOSTNAME}:30301/testwebapp/
```

With dashboard enabled, you can access the Traefik dashboard with URL `http://${HOSTNAME}:30301` with http Host `traefik.example.com`.

#### Install Path-routing Ingress TODO

## Unistall Traefik Operator
After removing all Ingress resources, uninstall Traefik operator.
```
helm delete --purge traefik-operator
```

## Tips
### Download Traefik Helm Chart locally
You can download Traefik helm chart and untar it to a local folder.
```
$ helm fetch  stable/traefik --untar
```
