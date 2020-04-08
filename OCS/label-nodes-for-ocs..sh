oc label node worker-3.ocp.example.net "cluster.ocs.openshift.io/openshift-storage=" --overwrite;
oc label node worker-3.ocp.example.net "topology.rook.io/rack=rack0" --overwrite;
oc label node worker-4.ocp.example.net "cluster.ocs.openshift.io/openshift-storage=" --overwrite;
oc label node worker-4.ocp.example.net "topology.rook.io/rack=rack1" --overwrite;
oc label node worker-5.ocp.example.net "cluster.ocs.openshift.io/openshift-storage=" --overwrite;
oc label node worker-5.ocp.example.net "topology.rook.io/rack=rack2" --overwrite;

