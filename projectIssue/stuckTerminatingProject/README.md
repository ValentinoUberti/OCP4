# List all resources in namespace
oc api-resources --verbs=list --namespaced -o name  | xargs -n 1 oc get --ignore-not-found
