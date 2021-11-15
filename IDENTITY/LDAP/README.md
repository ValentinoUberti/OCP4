# LDAP identityProvider

oc create secret generic ldap-secret --from-literal=bindPassword=<secret> -n openshift-config
  

oc create configmap ca-config-map --from-file=ca.crt=/path/to/ca -n openshift-config
  
 

# Groups filter

https://access.redhat.com/solutions/3510401


oc create secret generic ldap-group-sync --from-literal=username="uid=admin,cn=users,cn=accounts,dc=lab,dc=seeweb" --from-literal=password=

