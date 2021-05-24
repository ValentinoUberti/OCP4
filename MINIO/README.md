# Configuration 

https://github.com/minio/operator/blob/master/README.md
https://raw.githubusercontent.com/minio/operator/master/examples/tenant.yaml


```
cat <<EOF >minio_sc.yaml 
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
    name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer

EOF
```  

