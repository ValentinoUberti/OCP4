
# Checking vCenter user permissions

This is the automated version of: https://access.redhat.com/solutions/7051790

```
export VCENTER_URL=https://xxxxxxx
export session_id=$(curl -k -X POST-u 'vsphere.local\xxxxx: xxxx' $VCENTER_URL/rest/com/vmware/cis/session | jq -r '.value') 

echo "Checking datastore permission"

curl -X GET -H "vmware-api-session-id: $session_id" -H 'Accept: application/json' $VCENTER_URL/api/vcenter/datastore -k -w "\n" 

echo "Checking network permission"

curl -X GET -H "vmware-api-session-id: $session_id" -H 'Accept: application/json' $VCENTER_URL/api/vcenter/network -k -w "\n"
```

