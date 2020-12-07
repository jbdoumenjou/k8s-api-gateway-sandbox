#! /bin/sh
case "$1" in
  start)
    echo "Starting stack"
    k3d cluster delete mycluster
    k3d cluster create mycluster --api-port 6550 -p 80:80@loadbalancer -p 8080:8080@loadbalancer -p 443:443@loadbalancer --k3s-server-arg '--no-deploy=traefik' -i rancher/k3s:v1.18.6-k3s1

    # TODO delete when the image will be deployed
    k3d image import traefik/traefik:latest -c mycluster
  ;;
  step0)
    echo "As a Platform Provider: Add gateway resources definitions and create a GatewayClass for Traefik Controller"
    kubectl apply -f provider-resources/gateway-resources
    kubectl apply -f provider-resources/gatewayclass.yml
  ;;
  step1)
    echo "As a Platform Provider: Add Traefik Service"
    kubectl apply -f provider-resources/traefik-lb-rbac.yml
    kubectl apply -f provider-resources/traefik-lb-svc.yml
  ;;
  step2)
    echo "As a Platform Operator: Add Secret and Gateways referencing Traefik Controller GatewayClass"
    # TODO integrate cert-manager generation
    kubectl create secret tls mysecret --cert certs/whoami.pem --key certs/whoami-key.pem
    kubectl apply -f platform-operator-resources/
  ;;
  step3)
    echo "As a Service Operator: Add HTTPRoute and Services to route to"
    kubectl apply -f service-operator-resources/
  ;;
  clear)
    echo "Clear the stack"
    kubectl delete -f service-operator-resources/
    kubectl delete -f platform-operator-resources/
    kubectl delete -f provider-resources/
    kubectl delete secret tls mysecret
  ;;
  stop)
    echo "Stopping stack"
    k3d cluster delete mycluster
  ;;

  gcstatus)
    kubectl get gatewayclass -o json | jq ".items[] | .metadata.name , .status"
 ;;

  gstatus)
    kubectl get gateways -o json | jq ".items[] | .metadata.name , .status"
 ;;

esac
