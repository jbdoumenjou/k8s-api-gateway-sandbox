# Goal

A simple sandbox to test the kubernetes gateway provider on Traefik.

# Usage

Prerequisite: Having k3d installed.

This demo works by launching a shell script step by step.
It is splitting following the role defined in the Service API specifications.
Check the run.sh script for more details.

```shell script
# Create the stack
./run.sh start
# define resources and add GatewayClass
./run.sh step0
# Add Traefik as LoadBalancer with right RBAC
./run.sh step1
# Add secret & Gateway
./run.sh step2
# Add HTTPRoute & Whoami Service
./run.sh step3

# Show GatewayClass status 
./run.sh gcstatus
# Show Gateways statuses 
./run.sh gstatus
```
