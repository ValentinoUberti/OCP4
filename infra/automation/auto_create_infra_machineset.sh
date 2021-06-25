export MACHINESET_NAME=$(oc get machineset -n openshift-machine-api -o jsonpath="{.items[0].metadata.name}{'infra'}")
export CPU_CORE=8
export MEMORY_MB=65536

oc get machineset -n openshift-machine-api -o json\
| jq '.items[0]'\
| jq '.metadata.name=env["MACHINESET_NAME"]'\
| jq '.spec.selector.matchLabels."machine.openshift.io/cluster-api-machineset"=env["MACHINESET_NAME"]'\
| jq '.spec.template.metadata.labels."machine.openshift.io/cluster-api-machineset"=env["MACHINESET_NAME"]'\
| jq '.spec.template.spec.metadata.labels."node-role.kubernetes.io/infra"=""'\
| jq 'del (.metadata.annotations)'\
| jq 'del (.metadata.managedFields)'\
| jq 'del (.metadata.creationTimestamp)'\
| jq 'del (.metadata.generation)'\
| jq 'del (.metadata.resourceVersion)'\
| jq 'del (.metadata.selfLink)'\
| jq 'del (.metadata.uid)'\
| jq 'del (.status)'\
| jq '.spec.replicas=3'\
| jq '.spec.template.spec.providerSpec.value.cpu.cores=env["CPU_CORE"]'\
| jq '.spec.template.spec.providerSpec.value.memory_mb=env["MEMORY_MB"]'\
| oc create -f - 