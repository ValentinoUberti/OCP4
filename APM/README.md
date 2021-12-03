# Activate user workload monitoring

Edit or create the cluster-monitoring-config ConfigMap object in the openshift-monitoring Project:

- oc apply -f cluster-monitoring-config.yaml 

Assign the user-workload-monitoring-config-edit role to a user in the openshift-user-workload-monitoring project:

- oc -n openshift-user-workload-monitoring adm policy add-role-to-user user-workload-monitoring-config-edit <user> --role-namespace openshift-user-workload-monitoring

Deploy a sample app (namespace, deploy and service)
This application exposes the prometheus custom metrics via the /metrics endpoint

- oc apply -f sample_service.yaml

Specify how service is monitored

- oc apply -f service_monitor.yaml 

Apply the prometheus rule to detecting pod restarts

- oc apply -f prometheus_rule.yaml





