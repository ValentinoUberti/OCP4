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
kubernetes_host="https://api.ocp2.lab.seeweb:443"


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

```apiVersion: external-secrets.io/v1alpha1
kind: SecretStore
metadata:
  name: example
spec:
  provider:
    vault:
      server: "http://vault.mylab.mydomain:8200"
      path: "bjpath"
      version: "v2"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "cloud-app"
          serviceAccountRef:
            name: "sample-external-secrets"```

using v0.4.4


KubeApiBudget
PrometheusRemoteWriteBehind