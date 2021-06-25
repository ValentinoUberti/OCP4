

https://github.com/openshift/training/blob/master/docs/05-infrastructure-nodes.md

CLUSTER-API-CLUSTER=$(oc get -o jsonpath='{.status.infrastructureName}{"\n"}' infrastructure cluster)
MACHINESET_NAME=$(oc get machineset -o jsonpath="{.items[0].metadata.name}{'infra'}")
oc get machineset -n openshift-machine-api -o json\
| jq '.items[0]'\
| jq '.metadata.name=env["NAME"]'\
| jq '.spec.selector.matchLabels."machine.openshift.io/cluster-api-machineset"=env["MACHINESET_NAME"]'\
| jq '.spec.template.metadata.labels."machine.openshift.io/cluster-api-machineset"=env["MACHINESET_NAME"]'\
| jq '.spec.template.spec.metadata.labels."node-role.kubernetes.io/infra"=""'\
| jq 'del (.metadata.annotations)'\
| jq '.spec.replicas=3'\
| oc create -f -