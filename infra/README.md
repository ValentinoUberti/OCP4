# Creating infra machine set with taints

```

spec:
  replicas: 1
  selector:
    matchLabels:
      machine.openshift.io/cluster-api-cluster: ocp-kx4rj
      machine.openshift.io/cluster-api-machineset: ocp-kx4rj-infra-0
  template:
    metadata:
      labels:
        machine.openshift.io/cluster-api-cluster: ocp-kx4rj
        machine.openshift.io/cluster-api-machine-role: infra
        machine.openshift.io/cluster-api-machine-type: infra
        machine.openshift.io/cluster-api-machineset: ocp-kx4rj-infra-0
    spec:
      metadata:
        labels:
          node-role.kubernetes.io/infra: ''
      taints:
        - effect: NoSchedule
          key: node-role.kubernetes.io/infra
          value: ''


```

## Confirm created infra machine has got taints:

```
oc describe node ocp-kx4rj-infra-0-vx8fk | grep -i taints
```

## Add tollerations

Add tolerations for the pod configurations you want to schedule on the infra node, like router, registry, and monitoring workloads. Add the following code to the Pod object specification: <b>THIS IS NOT CLEAR! Look how to move the router...</b>

```
tolerations:
  - effect: NoSchedule 
    key: node-role.kubernetes.io/infra 
    operator: Exists 
```

## Moving the router

```
oc explain IngressController.spec.nodePlacement
```

```
spec:
  replicas: 2
  nodePlacement:
    nodeSelector:
      matchLabels:
        node-role.kubernetes.io/infra: ""
    tolerations:
      - effect: NoSchedule 
        key: node-role.kubernetes.io/infra 
        operator: Exists 
```

```
oc diff -f router.yaml
oc apply -f router.yaml
oc get pods -n openshift-ingress -o wide
```

## Moving the registry with tolerations

# IF USING OCS:
https://access.redhat.com/solutions/5061861

```
oc diff -f registry.yaml
oc apply -f registry.yaml
```


## Moving monitoring

```
oc diff -f cluster-monitoring-cm.yaml
oc apply -f cluster-monitoring-cm.yaml
```


# Logging

https://docs.openshift.com/container-platform/4.6/logging/cluster-logging-deploying.html

# Adding tolerations for infra nodes
https://docs.openshift.com/container-platform/4.6/logging/config/cluster-logging-tolerations.html

```
      nodeSelector: 
          node-role.kubernetes.io/infra: ''
      tolerations:
      - effect: NoSchedule 
        key: node-role.kubernetes.io/infra 
        operator: Exists
        tolerationSeconds: 6000
```
- spec->curation->curator->
- spec->logStore->elasticsearch->
- spec->visualization->kibana->

