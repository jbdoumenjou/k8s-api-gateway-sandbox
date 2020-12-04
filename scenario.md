# Goals

Propose a little journey into the freshly created Traefik (experimental) Gateway Provider.

# Step 1 - As Infrastructure/Platform Provider

We have to setup the environment.

Prerequisites  TODO
* k3d
* jq
* mkcert

Just like we want you to feel at home, you have a simple command to use `./run.sh start`

At this point, we have a running cluster with:
* The needed Gateway API custom resources definitions
* The GatewayClass allowing Traefik to be a controller
* The RBAC to allow Traefik to interact with the cluster
* Traefik as loadbalancer (listen to :80, :8080, :443) 
 
```
# check the cluster
kubectl get all
# check the GatewayClass status - Admitted true
kubectl get -o json GatewayClass/my-gateway-class | jq .status
{
  "conditions": [
    {
      "lastTransitionTime": "1970-01-01T00:00:00Z",
      "message": "Waiting for controller",
      "reason": "Waiting",
      "status": "Unknown",
      "type": "InvalidParameters"
    }
  ]
}
```
# Step 2 - As Platform Operator

* Define Secret for TLS 
* Define a Gateway
    
# Step 3 - As Service Operator

* Define Services to route to
* Define HTTPRoute


