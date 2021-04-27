 oc get cephobjectstoreusers.ceph.rook.io -n openshift-storage -o jsonpath="{.items[*].metadata.name}" | xargs oc patch -n openshift-storage --type=merge -p '{"metadata": {"finalizers":null}}' cephobjectstoreusers.ceph.rook.io
 oc get cephfilesystem.ceph.rook.io -n openshift-storage -o jsonpath="{.items[*].metadata.name}" | xargs oc patch -n openshift-storage --type=merge -p '{"metadata": {"finalizers":null}}' cephfilesystem.ceph.rook.io
 oc get cephobjectstore.ceph.rook.io -n openshift-storage -o jsonpath="{.items[*].metadata.name}" | xargs oc patch -n openshift-storage --type=merge -p '{"metadata": {"finalizers":null}}' cephobjectstore.ceph.rook.io
 oc get storagecluster.ocs.openshift.io  -n openshift-storage -o jsonpath="{.items[*].metadata.name}" | xargs oc patch -n openshift-storage --type=merge -p '{"metadata": {"finalizers":null}}' storagecluster.ocs.openshift.io 
 oc get cephblockpool.ceph.rook.io  -n openshift-storage -o jsonpath="{.items[*].metadata.name}" | xargs oc patch -n openshift-storage --type=merge -p '{"metadata": {"finalizers":null}}' cephblockpool.ceph.rook.io 
 oc get cephcluster.ceph.rook.io  -n openshift-storage -o jsonpath="{.items[*].metadata.name}" | xargs oc patch -n openshift-storage --type=merge -p '{"metadata": {"finalizers":null}}' cephcluster.ceph.rook.io 
 oc get sc -o jsonpath='{.items[?(@.metadata.name!="ovirt-csi-sc")].metadata.name}' | xargs oc delete sc 
 oc delete crd backingstores.noobaa.io bucketclasses.noobaa.io cephblockpools.ceph.rook.io cephclusters.ceph.rook.io cephfilesystems.ceph.rook.io cephnfses.ceph.rook.io cephobjectstores.ceph.rook.io cephobjectstoreusers.ceph.rook.io noobaas.noobaa.io ocsinitializations.ocs.openshift.io storageclusters.ocs.openshift.io cephclients.ceph.rook.io cephobjectrealms.ceph.rook.io cephobjectzonegroups.ceph.rook.io cephobjectzones.ceph.rook.io cephrbdmirrors.ceph.rook.io --wait=true --timeout=5m