#! /bin/sh
case "$1" in
  start)
    echo "Starting stack"
    k3d cluster delete mycluster
#    k3d cluster create mycluster --api-port 6550 --k3s-server-arg '--no-deploy=traefik' -i rancher/k3s:v1.18.6-k3s1
    k3d cluster create mycluster --api-port 6550 -p 80:80@loadbalancer -p 8080:8080@loadbalancer -p 443:443@loadbalancer --k3s-server-arg '--no-deploy=traefik' -i rancher/k3s:v1.18.6-k3s1
    k3d image import traefik/traefik:latest -c mycluster
    kubectl apply -f gateway-resources
    kubectl apply -f services
    kubectl create secret tls mysecret --cert certs/whoami.pem --key certs/whoami-key.pem
#    kubectl apply -f simple-http
  ;;
  reload)
    echo "Reload resources"
    kubectl apply -f gateway-resources
    kubectl apply -f services
  ;;
  stop)
    echo "Stopping stack"
    k3d cluster delete mycluster
  ;;

  gstatus)
    kubectl get gateways -o json | jq ".items[] | .metadata.name , .status"
 ;;

esac
