#list cluster admins
oc get clusterrolebindings -o json |
  jq '.items[] | select(.metadata.name=="cluster-admins") | .subjects[].name'
