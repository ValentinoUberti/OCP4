# Check whether the cluster-monitoring-config ConfigMap object exists:
oc -n openshift-monitoring get configmap cluster-monitoring-config

# If the ConfigMap object does not exist:
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
```

# APM
To configure the components that monitor user-defined projects, you must create the <b>user-workload-monitoring-config</b> ConfigMap object in the <b>openshift-user-workload-monitoring</b> project.

## Check whether the user-workload-monitoring-config ConfigMap object exists:

```
oc -n openshift-user-workload-monitoring get configmap user-workload-monitoring-config
```


If you are configuring components that monitor user-defined projects:

You have access to the cluster as a user with the cluster-admin role, or as a user with the <b>user-workload-monitoring-config-edit</b> role in the <b>openshift-user-workload-monitoring</b> project.

# Setting up metrics collection for user-defined projects

You can create a ServiceMonitor resource to scrape metrics from a service endpoint in a user-defined project. This assumes that your application uses a Prometheus client library to expose metrics to the /metrics canonical name.

To use the metrics exposed by your service, you must configure OpenShift Container Platform monitoring to scrape metrics from the /metrics endpoint. You can do this using a ServiceMonitor custom resource definition (CRD) that specifies how a service should be monitored, or a PodMonitor CRD that specifies how a pod should be monitored. The former requires a Service object, while the latter does not, allowing Prometheus to directly scrape metrics from the metrics endpoint exposed by a pod.

In OpenShift Container Platform 4.7, you can use the tlsConfig property for a ServiceMonitor resource to specify the TLS configuration to use when scraping metrics from an endpoint. The tlsConfig property is not yet available for PodMonitor resources. If you need to use a TLS configuration when scraping metrics, you <b>must</b> use ServiceMonitor resource.


# Is it possible to override the default metrics path (/metrics)

oc explain ServiceMonitor.spec.endpoints


oc -n ns1 get servicemonitor


As a developer, you must specify a project name when querying metrics. You must have the required privileges to view metrics for the selected project.

https://www.redhat.com/en/blog/custom-grafana-dashboards-red-hat-openshift-container-platform-4


envsubst < grafana_data_source.yaml | oc apply -f -


sum(rate(http_requests_total{namespace="ns1"}[2m]))



