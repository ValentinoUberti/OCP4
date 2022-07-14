# Loki test

server: loki.lab.seeweb

blog: https://cloud.redhat.com/blog/openshift-logging-forwarding-logs-to-external-loki

https://sbcode.net/grafana/logql/


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

```
1  exit
    2  mkdir -pv monitoring/{loki,promtail,grafana}/{data,config}
    3  podman
    4  dnf install -y podman
    5  pip3 install podman-compose
    6  dnf install pip3 -y
    7  dnf install python3-pip
    8  pip3 install podman-compose
    9  history
   10  tree
   11  vi monitoring/promtail/config/promtail-config.yaml
   12  vi monitoring/loki/config/loki-config.yaml
   13  ll
   14  podman-compose --project-name monitoring up -d
   15  ll
   16  cd monitoring/
   17  ll
   18  vi docker-compose.yaml
   19  cd ..
   20  podman-compose --project-name monitoring up -d
   21  cd monitoring/
   22  podman-compose --project-name monitoring up -d
   23  podman-compose --project-name monitoring down
   24  podman ps
   25  podman-compose --project-name monitoring up -d
   26  podman ps
   27  podman ps -a
   28  podman log 7b92854d4422
   29  podman logs 7b92854d4422
   30  tree
   31  ausearch
   32  ausearch -a storage
   33  journalctl -xef
   34  setsebool -P virt_qemu_ga_read_nonsecurity_files 1
   35  podman-compose --project-name monitoring down 
   36  podman-compose --project-name monitoring up -d
   37  podman ps
   38  podman ps -a
   39  podman logs 762c8ca68c6b
   40  tree
   41  vi docker-compose.yaml 
   42  podman-compose --project-name monitoring down 
   43  podman-compose --project-name monitoring up -d
   44  podman ps
   45  firewall-cmd --list-all
   46  vi /root/monitoring/grafana/data/provisioning/datasources/loki.yaml
   47  mkdir /root/monitoring/grafana/data/provisioning/datasources
   48  vi /root/monitoring/grafana/data/provisioning/datasources/loki.yaml
   49  podman pod ps
   50  podman ps
   51  podman pods
   52  podman pod
   53  podman pod ps
   54  podman pod restart monitoring
   55  podman ps
   56  podman restart monitoring_grafana_1
   57  podman ps
   58  vi /root/monitoring/grafana/data/provisioning/datasources/loki.yaml
   59  podman restart monitoring_grafana_1
   60  date
   61  exit
   62  top
   63  df -h
   64  treer
   65  tree
   66  du -h monitoring
   67  history
   ```


## Activate the stack

```
cd monitoring
podman-compose --project-name monitoring up -d
```

## Deactivate the stack

```
podman-compose --project-name monitoring down 
```

# Example query

## Extract warning from logs

```
{kubernetes_pod_name="intesa-adc-operator-2c597"} | json | level=~"warn"

count_over_time({log_type="application",kubernetes_namespace_name="adc"} | json | level=~"warn" [30m])

sum(count_over_time({log_type="application",kubernetes_namespace_name="adc"} | json | level=~"warn" [1m])) by (kubernetes_namespace_name)

sum(count_over_time({log_type="application",kubernetes_namespace_name="adc"} | json | level=~"warn" [$__range])) by (kubernetes_namespace_name)

```

##
Extract successfully ldap groups sync

```
count_over_time({log_type="application",kubernetes_namespace_name="group-sync-operator"}|~ "Sync Completed Successfully" [10m]))
```


# Line filter (like grep)

Get all applications logs containing the word "error"

```
{log_type="application"} |= "error"
```

Get all applications logs containing the word "error" and not the word "timeout"
```
{log_type="application"} |= "error" != "timeout"
```

# Parser

Used to parse logs to add labels

- json 
- logfmt (if there is a rfc complaint log format)
- pattern  (for example for the ngnix controller)
- regexp
- unpack


## json parser

```
{kubernetes_container_name="manager"} |= "error" | json
```

Example json from logs

```
{
  "pod.name" : { "id": "234"},
  "namespace: "test"
}
```

After parsing, we can access these vars:

- pod_name_id
- namespace

# Laber filter

After the parsering, we can apply label filter

```
{container="frontend"} |!=error | logfmt | duration > 1m and bytes_consumed > 20MB











