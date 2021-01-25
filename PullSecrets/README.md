# Changing pull secrets

https://access.redhat.com/solutions/4902871

- Download a new pull secrets 

```
oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson=pull-secret.txt
```

If secrets contains customizations:

```
oc extract secret/pull-secret -n openshift-config
```
edit .dockerconfigjson file

set data




