# Source Cluster Health Checks

oc get pods --all-namespaces|egrep -v 'Running | Completed'

oc get pods --all-namespaces --field-selector=status.phase=Running -o json | jq '.items[]|select(any( .status.containerStatuses[]; .restartCount > 5))|.metadata.name'

oc adm top node

oc get node -o wide
ssh node01
    ncat -vzu node02 4789
    ncat -vz master01 443


oc get csr | grep Pending

oc get csr -o go-template='{{range .items}}{{if not .status}}
{{.metadata.name}}{{"\n"}}{{end}}{{end}}' | xargs oc adm certificate approve

## Check certificate expiration
sudo -i
cd /usr/share/ansible/openshift-ansible
ansible-playbook -i /root/ocp3/hosts playbooks/openshift-checks/certificate_expiry/easy-mode.yaml

## SSH into master
source /etc/etcd/etcd.conf
export ETCDCTL_API=3

etcdctl3 --cert=$ETCD_PEER_CERT_FILE --key=$ETCD_PEER_KEY_FILE --cacert=$ETCD_TRUSTED_CA_FILE --endpoints=$ETCD_LISTEN_CLIENT_URLS --write-out=table endpoint health

## Run etcd test
docker run --volume /var/lib/etcd:/var/lib/etcd:Z  quay.io/openshift-scale/etcd-perf

## Run pvc test

create a fio pod and a pvc

 fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=/mnt/random_read_write.fio --bs=4k --iodepth=64 --size=200M --readwrite=randrw --rwmixread=75

## run ab to check avarage api response time
ab -c 500 -n 5000 -H 'Authorization: Bearer $TOKEN' https://master101.ocp3.example.com:443/api


## Verify NTP
for host in $(oc get nodes -o custom-columns=name:.metadata.name --no-headers) ; do ssh $host grep pool /etc/chrony.conf ; done

for host in $(oc get nodes -o custom-columns=name:.metadata.name --no-headers) ; do ssh $host 'sudo chronyc tracking | grep "Leap status"' ; done

# Target Cluster Health Checks

- network
- access to the shard registry
- check for obsolete image tags
- check for networkpolicies

## NTP

for host in $(oc get nodes -o custom-columns=name:.metadata.name --no-headers) ; do  ssh -i .ssh/lab_rsa core@${host} grep pool /etc/chrony.conf ; done

for host in $(oc get nodes -o custom-columns=name:.metadata.name --no-headers) ; do  ssh -i .ssh/lab_rsa core@${host} 'sudo chronyc tracking | grep "Leap status"'; done

## Etcd tests
sudo podman run --volume /var/lib/etcd:/var/lib/etcd:Z  quay.io/openshift-scale/etcd-perf