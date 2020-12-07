# Goals

Let's play with the freshly created Traefik (experimental) Gateway Provider.

We decided to split the scenario regarding the roles defined by Gateway APIs.
At each step, we will add only needed resources and check the statuses thanks to a shell script.
Our goal is to route HTTP and HTTPS traffic to a whoami backend and observe the Gateway API resources behavior.


# Start - As Infrastructure/Platform Provider

The very first step is to launch the kubernetes cluster and start from scratch.
 
```shell script
 ./run.sh start
```

We are now ready to add resources to the cluster.

# Step 0 - As Infrastructure/Platform Provider

* Add Gateway resources definitions to the Kubernetes Cluster 
* Add a GatewayClass to allow Traefik to handle it as a Controller

```shell script
./run.sh step0

# check the GatewayClass status - Should be Admitted false
kubectl get -o json GatewayClass/my-gateway-class | jq .status
```

# Step 1 - As Infrastructure/Platform Provider

* Add the RBAC to allow Traefik to interact with the cluster
* Add Traefik as loadbalancer (listen to :80, :8080, :443) 


```
./run.sh step1

# check the GatewayClass
kubectl get GatewayClasses

# check the GatewayClass status - Should be Admitted true
kubectl get -o json GatewayClass/my-gateway-class | jq .status
```

# Step 2 - As Platform Operator

* Define Secret for TLS 
* Define Gateways

```
./run.sh step2

# check the GatewayClass status - Ready False because the HTTPRoutes are not yet deployed
kubectl get gateways -o json | jq ".items[] | .metadata.name , .status"
```

    
# Step 3 - As Service Operator

* Define Services to route to
* Define HTTPRoute


```
./run.sh step3

# check the GatewayClass status - Ready False because the HTTPRoutes are not yet deployed
kubectl get gateways -o json | jq ".items[] | .metadata.name , .status"
```

# Let's play with cluster

* Modify HTTPRoute
  * to show that it works well
  * to show errors and related statuses
