https://examples.openshift.pub/cluster-configuration/full-cluster-entitlement/


# MCP
```
oc get node -o custom-columns=NAME:metadata.name,STATE:metadata.annotations."machineconfiguration\.openshift\.io/state",DESIRED:metadata.annotations."machineconfiguration\.openshift\.io/desiredConfig",CURRENT:metadata.annotations."machineconfiguration\.openshift\.io/currentConfig",REASON:metadata.annotations."machineconfiguration\.openshift\.io/reason"
```

# MCP

https://access.redhat.com/solutions/6980129
