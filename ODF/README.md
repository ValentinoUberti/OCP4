https://computingforgeeks.com/configure-ceph-toolbox-for-rook-on-kubernetes-openshift/

# Enable ceph tool
oc patch OCSInitialization ocsinit -n openshift-storage --type json --patch  '[{ "op": "replace", "path": "/spec/enableCephTools", "value": true }]'
