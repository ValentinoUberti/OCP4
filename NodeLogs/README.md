
oc adm node-logs ocp-s4bt4-master-0 --path=openshift-apiserver/audit.log > audit.log

cat audit.log | jq -s 'group_by(.requestURI) | map ({"url": .[0].requestURI,"username": .[0].user.username, "total": length}) | sort_by(.total)'

```
{
    "url": "/apis/build.openshift.io/v1/namespaces/custom-grafana/buildconfigs",
    "username": "system:serviceaccount:kube-system:namespace-controller",
    "total": 293
  },
  {
    "url": "/apis/authorization.openshift.io/v1/namespaces/custom-grafana/roles",
    "username": "system:serviceaccount:kube-system:namespace-controller",
    "total": 308
  },
  {
    "url": "/openapi/v2",
    "username": "system:aggregator",
    "total": 539
  },
  {
    "url": "/apis/project.openshift.io/v1/projects?limit=500",
    "username": "system:serviceaccount:argocd:argocd-application-controller",
    "total": 1153
  }


```