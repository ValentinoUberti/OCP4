oc new-project test-injector
helm version (should be > 3)
helm repo add hashicorp https://helm.releases.hashicorp.com
helm search repo hashicorp/vault -l
helm install vault hashicorp/vault --set "injector.externalVaultAddr=http://vault.lab.seeweb:8200" --set "global.openshift=true"

cat <<EOF | oc create -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: webapp
EOF

```
vale@fedorone HashiCorp]$ oc get sa
NAME                   SECRETS   AGE
builder                2         22m
default                2         22m
deployer               2         22m
vault                  2         4m28s
vault-agent-injector   2         4m28s
webapp                 2         8s
```
### On Vault Server

export VAULT_ADDR=http://0.0.0.0:8200
vault login

vault kv put secret/devwebapp/config username='giraffe' password='salsa'

vault policy write devwebapp - <<EOF
path "secret/data/devwebapp/config" {
  capabilities = ["read"]
}
EOF

vault write auth/kubernetes/role/devweb-app \
        bound_service_account_names=webapp \
        bound_service_account_namespaces=test-injector \
        policies=devwebapp \
        ttl=24h


TOKEN_REVIEW_JWT=$(oc sa get-token vault)
KUBE_CA_CERT=$(cat k8-ca.crt)
KUBE_HOST="https://api.ocp3.lab.seeweb:6443"

vault write auth/kubernetes/config token_reviewer_jwt="$TOKEN_REVIEW_JWT" kubernetes_host="$KUBE_HOST" kubernetes_ca_cert="$KUBE_CA_CERT" disable_local_ca_jwt=true



oc create -f pod.yaml

# oc exec  devwebapp-with-annotations -- cat /vault/secrets/credentials.txt

Defaulted container "app" out of: app, vault-agent, vault-agent-init (init)
data: map[password:salsa username:giraffe]
metadata: map[created_time:2022-04-15T09:42:38.56489184Z custom_metadata:<nil> deletion_time: destroyed:false version:1]

