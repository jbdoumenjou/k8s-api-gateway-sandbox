#! /bin/sh
case "$1" in
  step1)
    echo "Starting stack"
    k3d cluster delete mycluster
    k3d cluster create mycluster --api-port 6550 -p 80:80@loadbalancer -p 8080:8080@loadbalancer -p 443:443@loadbalancer --k3s-server-arg '--no-deploy=traefik' -i rancher/k3s:v1.18.6-k3s1

    # TODO delete when the image will be deployed
    k3d image import traefik/traefik:latest -c mycluster

    kubectl apply -f provider-resources/gateway-resources
    kubectl apply -f provider-resources/gatewayclass.yml

    kubectl apply -f provider-resources/traefik-lb-rbac.yml
    kubectl apply -f provider-resources/traefik-lb-svc.yml
  ;;
  step2)
    # TODO integrate cert-manager generation
    kubectl create secret tls mysecret --cert certs/whoami.pem --key certs/whoami-key.pem
    kubectl apply -f platform-operator-resources/
  ;;
  step3)
    kubectl apply -f service-operator-resources/
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
