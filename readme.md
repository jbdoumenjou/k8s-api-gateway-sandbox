# Goal

A simple sandbox to test the kubernetes gateway provider on Traefik.

# Usage

Prerequisite: Having k3d installed.

```shell script
k3d cluster create mycluster --api-port 6550 -p 80:80@loadbalancer -p 8080:8080@loadbalancer -p 443:443@loadbalancer --k3s-server-arg '--no-deploy=traefik' -i rancher/k3s:v1.18.6-k3s1
k3d image import traefik/traefik:latest -c mycluster


kubectl get -o json gateways/my-gateway-httproute-bad-port | jq .status   
```
