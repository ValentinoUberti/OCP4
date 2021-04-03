https://access.redhat.com/solutions/5504291


oc extract -n openshift-machine-api secret/master-user-data --keys=userData --to=-
oc extract -n openshift-machine-api secret/worker-user-data --keys=userData --to=-
