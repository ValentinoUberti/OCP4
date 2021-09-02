oc get etcd -o=jsonpath='{range .items[0].status.conditions[?(@.type=="EtcdMembersAvailable")]}{.message}{"\n"}'

oc get machines -A -ojsonpath='{range .items[*]}{@.status.nodeRef.name}{"\t"}{@.status.providerStatus.instanceState}{"\n"}' | grep -v running

oc get nodes -o jsonpath='{range .items[*]}{"\n"}{.metadata.name}{"\t"}{range .spec.taints[*]}{.key}{" "}' | grep unreachable

oc get pods -n openshift-etcd | grep -v etcd-quorum-guard | grep etcd

oc rsh -n openshift-etcd etcd-ocp-8wcjz-master-1

+------------------+---------+--------------------+---------------------------+---------------------------+------------+
|        ID        | STATUS  |        NAME        |        PEER ADDRS         |       CLIENT ADDRS        | IS LEARNER |
+------------------+---------+--------------------+---------------------------+---------------------------+------------+
| 1ce6b972a3e5d2cc | started | ocp-8wcjz-master-0 | https://172.27.4.206:2380 | https://172.27.4.206:2379 |      false |


oc get secrets -n openshift-etcd | grep ip-10-0-131-183.ec2.internal 
## delete all associated secrets


oc get machine clustername-8qw5l-master-0 -n openshift-machine-api -o yaml > new-master-machine.yaml

clean new-master-machine.yaml

