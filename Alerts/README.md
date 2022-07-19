# Check active alerts from cli

https://www.linkedin.com/pulse/lightweight-method-query-active-alerts-alertmanager-openshift-moses/


```
export ALERTMANAGER_ROUTE=`oc -n openshift-monitoring get route alertmanager-main -o jsonpath='{.spec.host}'`
echo $ALERTMANAGER_ROUTE
curl -k -H "Authorization: Bearer $(oc -n openshift-monitoring sa get-token prometheus-k8s)" https://$ALERTMANAGER_ROUTE/api/v1/alerts | jq '.data[].labels.alertname'
```
