# Maximo Service License Suite Module

Module to populate a gitops repository with the SLS operator subscription and LicenseService(instance) for MAS. 

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v12
- kubectl

### Terraform providers

- IBM Cloud provider >= 1.5.3
- Helm provider >= 1.1.1 (provided by Terraform)

## Module dependencies

This module makes use of the output from other modules:

- Argocd Bootstrap - github.com/cloud-native-toolkit/terraform-tools-argocd-bootstrap.git
- GitOps - github.com/cloud-native-toolkit/terraform-tools-gitops.git
- Cluster - github.com/cloud-native-toolkit/terraform-ibm-ocp-vpc.git
- Namespace - github.com/cloud-native-toolkit/terraform-gitops-namespace.git
- Catalog - github.com/cloud-native-toolkit/terraform-gitops-cp-catalogs.git
- MongoDB - github.com/cloud-native-toolkit/terraform-gitops-mongo-ce.git

## Example usage

```hcl-terraform
module "sls" {
  source = "https://github.com/cloud-native-toolkit/terraform-gitops-cp-sls"
  
  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials

  server_name = module.gitops.server_name

  kubeseal_cert = module.gitops.sealed_secrets_cert
  catalog = module.cp_catalogs.catalog_ibmoperators
  namespace   = module.dev_namespace.name
  mongo_userid    = module.mongodb.username
  mongo_dbpass    = module.mongodb.password
  mongo_namespace = module.mongodb.namespace
  mongo_svcname   = module.mongodb.svcname
  mongo_cacrt     = module.mongodb.cacrt
  mongo_port      = module.mongodb.port
  cluster_ingress = module.dev_cluster.platform.ingress
  entitlement_key  = module.cp_catalogs.entitlement_key
  
}
```

