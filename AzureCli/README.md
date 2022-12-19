# Install Azure Cli (az)

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=dnf

- sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
- sudo dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm
- sudo dnf install azure-cli

## Login

- az login -u <username> -p <password>
- read -sp "Azure password: " AZ_PASS && echo && az login -u <username> -p $AZ_PASS

## ResourceGroups

- az group list
- az group show --resource-group 1-e26b67d6-playground-sandbox

## Subscriptions

- az account show

## Vms

- az vm create

[
  {
    "id": "/subscriptions/0f39574d-d756-48cf-b622-0e27a6943bd2/resourceGroups/1-e26b67d6-playground-sandbox",
    "location": "centralus",
    "managedBy": null,
    "name": "1-e26b67d6-playground-sandbox",
    "properties": {
      "provisioningState": "Succeeded"
    },
    "tags": null,
    "type": "Microsoft.Resources/resourceGroups"
  }
]

- az vm create --resource-group 1-e26b67d6-playground-sandbox --location centralus --name vm-demo-001 --image UbuntuLTS --admin-username vale --generate-ssh-keys --no-wait

# Azure Policy

Enforce compliance and enable auditing
- governance
- compliance
- Cost control
- restrict service access
- Geographical compliance
- GDPR

## Policy Definition
- policy definition
- audit or deny

### Policy Assignement
- Set a specific scope
  - Subscription
  - Management groups
  - Resource groups

### Initiative Definition
A collection of policies that are tailored to achieving a singolat high-level goal togheter (e.g. ensuring that VMs meet standards)


# Resource Tagging
- tag subcriptions (eg env:prod)
- tags are not inherited
- resources can have up to 50 tags

```
- az group list
- az group update -n <resourceGroup> --tags <key=value>
- az vm list --query '[].{name:name, resorceGroup:resourceGroup, tags:tags}' -o json
- az network vnet list --query '[].{name:name, resorceGroup:resourceGroup, tags:tags}' -o json

