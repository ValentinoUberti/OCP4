#Export and trust the default ingress CA

```
oc get secret -n openshift-ingress-operator router-ca -o=jsonpath="{.data['tls\.crt']}" | base64 -d > router.crt

cp router.crt /etc/pki/ca-trust/source/anchors/

update-ca-trust
```

