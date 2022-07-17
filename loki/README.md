# Loki test

server: loki.lab.seeweb

## blog: 

https://cloud.redhat.com/blog/openshift-logging-forwarding-logs-to-external-loki

https://sbcode.net/grafana/logql/

## Loki install on external VM (Fedora 36) using podman-compose

```
mkdir -pv monitoring/{loki,promtail,grafana}/{data,config}
mkdir -pv monitoring/grafana/data/provisiong/datasources
dnf install -y podman
dnf install python3-pip
pip3 install podman-compose
cd monitoring/
setsebool -P virt_qemu_ga_read_nonsecurity_files 1
```

## Edit and copy configuration yamls

```
cp promtail-config-yaml  monitoring/promtail/config/promtail-config.yaml
cp loki-config.yaml      monitoring/loki/config/loki-config.yaml
cp loki.yaml             monitoring/grafana/data/provisiong/datasources/loki.yaml
```


## Install the OpenShift Logging Operator

## Create the ClusterLogging CR on OpenShift
```
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
```

## Create the ClusterLogForwarder CR on OpenShift

```
apiVersion: logging.openshift.io/v1
kind: ClusterLogForwarder
metadata:
  name: instance
  namespace: openshift-logging
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

## Activate the stack on the loki server

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

```

# Example Dashboard

<img src="./images/Screenshot from 2022-07-17 19-42-09.png">

