
# Retrive admin user and pass
oc get secret/credential-example-keycloak -o go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'


# Run the following to find out the URLs of Keycloak:

$ KEYCLOAK_URL=https://$(oc get route keycloak --template='{{ .spec.host }}')/auth &&
echo "" &&
echo "Keycloak:                 $KEYCLOAK_URL" &&
echo "Keycloak Admin Console:   $KEYCLOAK_URL/admin" &&
echo "Keycloak Account Console: $KEYCLOAK_URL/realms/myrealm/account" &&
echo ""


https://www.keycloak.org/getting-started/getting-started-operator-openshift

