# Hahicorp Vault

https://learn.hashicorp.com/tutorials/vault/raft-deployment-guide?in=vault/raft

- sudo yum install -y yum-utils
- sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
- sudo yum -y install vault

- generate host certificates

cp vault.crt /opt/vault/tls/vault-cert.pem
cp vault.key /opt/vault/tls/vault-key.pem
cp ca.crt /opt/vault/tls/vault-ca.pem

- fix certs permissions

 chown root:root /opt/vault/tls/vault-cert.pem /opt/vault/tls/vault-ca.pem
 chown root:vault /opt/vault/tls/vault-key.pem
 chmod 0644 /opt/vault/tls/vault-cert.pem /opt/vault/tls/vault-ca.pem
 chmod 0640 /opt/vault/tls/vault-key.pem

 ## Configuration

 The Vault TLS certificate itself, which a Common Name (CN) or Subject Alternative Name (SAN) that matches the value set for leader_tls_servername in the Raft configuration

 - export VAULT_CACERT=/opt/vault/tls/vault-ca.pem
 - export VAULT_ADDR='https://vault.lab.seeweb:8200'

[root@vault certificates]# cat /etc/hosts 
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
172.19.0.156 vault.lab.seeweb

cat /etc/vault.d/vault.hcl

```# Full configuration options can be found at https://www.vaultproject.io/docs/configuration

ui = true

api_addr      = "https://vault.lab.seeweb:8200"

#mlock = true
#disable_mlock = true

storage "file" {
  path = "/opt/vault/data"
}

#storage "consul" {
#  address = "127.0.0.1:8500"
#  path    = "vault"
#}

# HTTP listener
#listener "tcp" {
#  address = "127.0.0.1:8199"
#  tls_disable = 1
#}

# HTTPS listener
listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/opt/vault/tls/vault-cert.pem"
  tls_key_file  = "/opt/vault/tls/vault-key.pem"
  tls_client_ca_file = "/opt/vault/tls/vault-ca.pem"
}

# Enterprise license_path
# This will be required for enterprise as of v1.8
#license_path = "/etc/vault.d/vault.hclic"

# Example AWS KMS auto unseal
#seal "awskms" {
#  region = "us-east-1"
#  kms_key_id = "REPLACE-ME"
#}

# Example HSM auto unseal
#seal "pkcs11" {
#  lib            = "/usr/vault/lib/libCryptoki2_64.so"
#  slot           = "0"
#  pin            = "AAAA-BBBB-CCCC-DDDD"
#  key_label      = "vault-hsm-key"
#  hmac_key_label = "vault-hsm-hmac-key"
#}```

# Operations

- vault status
- vault operator init

Initial Root Token: s.4AfcGwGhZNGRQCyysv1UaxId


Unseal Key 1: kFPPPI4drCFnHEzkHE8ZKIGSJMlO1eN4h/EPvh0WcOCJ
Unseal Key 2: WEfET7Z4G06R1DoZ2nRxTuF8bt3fjtX4X/Qo0oM/DxcC
Unseal Key 3: tFD3YwK0CZ5WbDQJppVyfSTsT8AgU6IMMDlrkaX90Z5G
Unseal Key 4: 24bEl9T2Q/Wk0P29vsAEyFZStdbQenlozFiy4RSo0POh
Unseal Key 5: esWN9BJEq6atW3WPcPct3pd785B1fXR6rEmaIEVqie82

- vault operator unseal

# Integrate a Kubernetes Cluster with an External Vault
https://learn.hashicorp.com/tutorials/vault/kubernetes-external-vault

- vault login s.4AfcGwGhZNGRQCyysv1UaxId

vault secrets enable -path=bjpath kv-v2
vault kv put bjpath/database/credentials \
  username="db-username" \
  password="db-password"

vault policy write cloud-app - <<EOF
path "bjpath/database/credentials" {
  capabilities = ["read"]
}
EOF

https://blog.ramon-gordillo.dev/2021/03/gitops-with-argocd-and-hashicorp-vault-on-kubernetes/



vault write auth/kubernetes/config \
kubernetes_host="https://api.ocp2.lab.seeweb:6443"


vault write auth/kubernetes/role/cloud-app \
    bound_service_account_names=cloud-app-sa \
    bound_service_account_namespaces=openshift-gitops \
    policies=cloud-app \
    ttl=24h

vault write auth/kubernetes/role/cloud-app \
    bound_service_account_names=sample-external-secrets \
    bound_service_account_namespaces=openshift-gitops \
    policies=cloud-app \
    ttl=24h

https://external-secrets.io/v0.4.4/provider-hashicorp-vault/

vault kv put secret/foo my-value=s3cr3t


export VAULT_ADDR=https://vault.lab.seeweb:8200

----------

Using a SecretStore, the vault provider with Kubernetes auth returns this error on OpenShift 4.9:

```open /var/run/secrets/kubernetes.io/serviceaccount/ca.crt: no such file or directory"```

This is the SecretStore CR:

```
apiVersion: external-secrets.io/v1alpha1
kind: SecretStore
metadata:
  name: example
  namespace: test-external-secret
spec:
  provider:
    vault:
      server: "http://vault.lab.seeweb:8200"
      path: "path"
      version: "v2"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "demo"
          serviceAccountRef:
            name: "external-secrets-operator-controller-manager"```

using v0.4.4


KubeApiBudget
PrometheusRemoteWriteBehind



-------------------------ù

vault auth enable kubernetes


vault write auth/kubernetes/config \
    token_reviewer_jwt="eyJhbGciOiJSUzI1NiIsImtpZCI6ImF6a3lLMnVMV2ZiWnR0NFJQLWMyVUpGdFpRdDk4SEhuZWFtdVlxVXJSR3cifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJ0ZXN0LWV4dGVybmFsLXNlY3JldCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJleHRlcm5hbC1zZWNyZXRzLW9wZXJhdG9yLWNvbnRyb2xsZXItbWFuYWdlci10b2tlbi01d21idiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJleHRlcm5hbC1zZWNyZXRzLW9wZXJhdG9yLWNvbnRyb2xsZXItbWFuYWdlciIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjUyMmJhYzJjLTRlZmYtNDk5ZS05ZmIzLTEyNzlmMDhiNWFlNCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDp0ZXN0LWV4dGVybmFsLXNlY3JldDpleHRlcm5hbC1zZWNyZXRzLW9wZXJhdG9yLWNvbnRyb2xsZXItbWFuYWdlciJ9.RvPn-j6qU2BT18X2NIPB1Upu9S34QMFrM3Ou0vWU2L8dlhNFNLrBCb8LBWb4LEJIc2OTUxyeK-ilBy2ogcsfTpbpQsyPM2kg6PXk24gCn7LQrsxgaOL-HlVOsYIdFhdvSXd1y7c6I5v8HlYIBdUEF_k3URMKEGLkz2csIbHQmCvL3EFB5ECWuVjuqBIr28MUvCSwXhThpqYgXuQvxGEUCcuaS27PZnoN5Jg5LCO_MeyP6xiavV6w0RkcSZrEtPRec76e7IqKpVWiCIOhPhZCWOPhUjvV0Xs3v86ypsVPHwdfkSwJr6xJdeXT7OoQ4YsavKOyhL5-rGvNm4OzRNauEQ" \
    kubernetes_host=https://api.ocp3.lab.seeweb:6443 \
    kubernetes_ca_cert=@k8-ca.crt disable_local_ca_jwt="true”


vault write auth/kubernetes/role/demo \
    bound_service_account_names=sample-external-secrets \
    bound_service_account_namespaces=test-external-secret \
    policies=demo \
    ttl=1h

vault secrets enable -path=mypath kv-v2

vault kv put mypath/database/credentials \
  username="db-username" \
  password="db-password"

vault policy write demo - <<EOF
path "mypath/database/credentials" {
  capabilities = ["read","list"]
}
EOF


vault write auth/kubernetes/login role=demo jwt="eyJhbGciOiJSUzI1NiIsImtpZCI6ImF6a3lLMnVMV2ZiWnR0NFJQLWMyVUpGdFpRdDk4SEhuZWFtdVlxVXJSR3cifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJ0ZXN0LWV4dGVybmFsLXNlY3JldCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJzYW1wbGUtZXh0ZXJuYWwtc2VjcmV0cy10b2tlbi10OGM5bCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJzYW1wbGUtZXh0ZXJuYWwtc2VjcmV0cyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjQwMzI4Yjc0LTJkMGQtNGEyNy05MWNlLTE3MzdlZTFmNDZjNyIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDp0ZXN0LWV4dGVybmFsLXNlY3JldDpzYW1wbGUtZXh0ZXJuYWwtc2VjcmV0cyJ9.okr-DTf6KyaOhdt9sBU9k9QvespHGHRfHLeUT_YW3HSw6WA4-9G16LRc7A46qRlQeXXokZq9oFOeT101b747HaB2cbc4JA3rdG8RgmD8D7dqR2yWVY09L3AFvm9TG2C4TikPaTUuWoa0lDLI3cqCj1IuKz9iTm_NEAFzZfbycDAsXNAitZlZ67IMUHmf0eF18uhc3ebAixWUu3KkeE7XkzCn9Rite_aVvBJTmMNRdVJlbA9-bm4yrs9uqTyY317dwlCquuZJkuJlGzHH0vsr4H2OfhYddlGJjG0w9UXtsvk7a3iblwTHlCL9wDPkJJ69-Onvp8cdk3FePJI-ZPXtNA"



vault write auth/kubernetes/config \
   token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
   kubernetes_host=https://api.ocp2.lab.seeweb:6443 \
   kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt



oc get secret vault-reviewer-token-vq9sl -o jsonpath="{.data['ca\.crt']}" | base64 --decode > k8-ca.crt

oc adm policy add-cluster-role-to-user system:auth-delegator -z external-secrets-operator-controller-manage

------------------------------------------


cat <<EOF | oc create -f -
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: test-cloud
  namespace: test-external-secret
---
apiVersion: v1
kind: Secret
metadata:
 name: test-cloud
 namespace: test-external-secret
 annotations:
   kubernetes.io/service-account.name: test-cloud
type: kubernetes.io/service-account-token
EOF


-------------------------

https://support.hashicorp.com/hc/en-us/articles/4404389946387-Kubernetes-auth-method-Permission-Denied-error

Working configuration




cat <<EOF | oc create -f -
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: vault-auth
---
apiVersion: v1
kind: Secret
metadata:
  name: vault-auth
  annotations:
    kubernetes.io/service-account.name: vault-auth
type: kubernetes.io/service-account-token
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: role-tokenreview-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
  - kind: ServiceAccount
    name: vault-auth
    namespace: test-external-secret
  - kind: ServiceAccount
    name: test-cloud
    namespace: test-external-secret
EOF


TOKEN_REVIEW_JWT=$(oc get secret vault-auth -o go-template='{{ .data.token }}' | base64 --decode)
KUBE_CA_CERT=$(cat k8-ca.crt)
KUBE_HOST="https://api.ocp3.lab.seeweb:6443"

vault write auth/kubernetes/config token_reviewer_jwt="$TOKEN_REVIEW_JWT" kubernetes_host="$KUBE_HOST" kubernetes_ca_cert="$KUBE_CA_CERT" disable_local_ca_jwt=true



vault policy write devwebapp - <<EOF
path "secret/data/devwebapp/config" {
  capabilities = ["read","list"]
}
EOF


vault write auth/kubernetes/role/devweb-app \
  bound_service_account_names=test-cloud \
  bound_service_account_namespaces=test-external-secret \
  policies=devwebapp \
  ttl=24h


TOKEN_REVIEW_JWT=$(oc get secret  test-cloud -n test-external-secret -o go-template='{{ .data.token }}' | base64 --decode)


curl --request POST --data '{"jwt": "'$TOKEN_REVIEW_SJWT'", "role": "devweb-app"}' http://127.0.0.1:8200/v1/auth/kubernetes/login

vault secrets enable -path=mypath kv-v2

vault kv put mypath/database/credentials \
  username="db-username" \
  password="db-password"

vault policy write devwebapp - <<EOF
path "mypath/data/database/credentials" {
  capabilities = ["read"]
}
EOF


-----------------

apiVersion: external-secrets.io/v1alpha1
kind: SecretStore
metadata:
  name: example
  namespace: test-external-secret
spec:
  provider:
    vault:
      auth:
        kubernetes:
          mountPath: kubernetes
          role: devweb-app
          serviceAccountRef:
            name: test-cloud
      path: mypath
      server: 'http://vault.lab.seeweb:8200'
      version: v2

-------------
apiVersion: external-secrets.io/v1alpha1
kind: SecretStore
metadata:
  name: example
  namespace: test-external-secret
spec:
  provider:
    vault:
      auth:
        kubernetes:
          mountPath: kubernetes
          role: devweb-app
          serviceAccountRef:
            name: test-cloud
      path: mypath
      server: 'http://vault.lab.seeweb:8200'
      version: v2
