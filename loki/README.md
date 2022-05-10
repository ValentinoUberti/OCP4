# Loki test

server: loki.lab.seeweb

blog: https://cloud.redhat.com/blog/openshift-logging-forwarding-logs-to-external-loki

# Loki install

mkdir -pv monitoring/{loki,promtail,grafana}/{data,config}
mkdir -pv /root/monitoring/grafana/data/provisioning/datasources

dnf install -y podman python3-pip
pip3 install podman-compose

scp promtail-config-yaml  loki.lab.seeweb:/monitoring/promtail/config/promtail-config.yaml

cat /root/monitoring/grafana/data/provisioning/datasources/loki.yaml

```
apiVersion: 1
datasources:
 - name: Loki
   type: loki
   access: proxy
   orgId: 1
   url: http://loki-server:3100
   isDefault: true
   version: 1
   editable: true
```

## Cluster logging

apiVersion: "logging.openshift.io/v1"
kind: "ClusterLogging"
metadata:
  name: "instance"
  namespace: "openshift-logging"
spec:
  managementState: "Managed"
  collection:
    logs:
      type: "fluentd"
      fluentd: {}

## ClusterLogForwarder

apiVersion: logging.openshift.io/v1
kind: ClusterLogForwarder
metadata:
  creationTimestamp: '2022-05-10T08:19:46Z'
  generation: 3
  managedFields:
    - apiVersion: logging.openshift.io/v1
      fieldsType: FieldsV1
      fieldsV1:
        'f:spec':
          .: {}
          'f:outputs': {}
          'f:pipelines': {}
      manager: Mozilla
      operation: Update
      time: '2022-05-10T08:19:46Z'
    - apiVersion: logging.openshift.io/v1
      fieldsType: FieldsV1
      fieldsV1:
        'f:status':
          .: {}
          'f:conditions': {}
      manager: cluster-logging-operator
      operation: Update
      subresource: status
      time: '2022-05-10T08:19:46Z'
  name: instance
  namespace: openshift-logging
  resourceVersion: '368621526'
  uid: 553a4cff-d3c4-49c8-b47a-204657b6894d
spec:
  outputs:
    - name: remoteloki
      type: loki
      url: 'http://loki.lab.seeweb:3100'
  pipelines:
    - inputRefs:
        - application
        - infrastructure
        - audit
      outputRefs:
        - remoteloki

