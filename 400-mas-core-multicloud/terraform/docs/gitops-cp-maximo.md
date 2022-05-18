#  Maximo Application Suite Gitops terraform module
![Verify and release module](https://github.com/cloud-native-toolkit/terraform-gitops-cp-maximo/workflows/Verify%20and%20release%20module/badge.svg)

Deploys Maximo Application Suite via gitops - Currently this deploys through MAS-Core via Gitops. Please note the suggested companion modules.  To run, download the BOM (Bill of Materials) from the module catalog and build the terraform from there.  Specify your connection to the cluster, the install will install the latest version of Maximo Application Suite Core - by default it currently uses "masapps" as the instanceid.  This is configurable, set the `instanceid` variable upon deployment.  This will create a namespace of the name "mas-(instanceid)-core".

Note if your cluster is not setup for gitops, download the gitops bootstrap BOM from the module catalog first to setup the gitops tooling.

## Supported platforms

- OCP 4.6+

## Suggested companion modules

The module itself requires some information from the cluster and needs a
namespace to be created. The following companion
modules can help provide the required information:

- Gitops:  github.com/cloud-native-toolkit/terraform-tools-gitops
- Gitops Bootstrap: github.com/cloud-native-toolkit/terraform-util-gitops-bootstrap
- Namespace:  github.com/ibm-garage-cloud/terraform-cluster-namespace
- Pull Secret:  github.com/cloud-native-toolkit/terraform-gitops-pull-secret
- Catalog: github.com/cloud-native-toolkit/terraform-gitops-cp-catalogs 
- Cert:  github.com/cloud-native-toolkit/terraform-util-sealed-secret-cert
- Cluster: github.com/cloud-native-toolkit/terraform-ocp-login
- CertManager: github.com/cloud-native-toolkit/terraform-gitops-ocp-cert-manager

## Example usage

```hcl-terraform
module "mas_appsuite" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cp-maximo"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  kubeseal_cert = module.gitops.sealed_secrets_cert
  entitlement_key = module.catalog.entitlement_key
  cluster_ingress = module.dev_cluster.platform.ingress
  catalog_name = module.catalog.catalog_ibmoperators
  instanceid = "mas8"
  certmgr_namespace = "ibm-common-services"

}
```

## Cleanup

Note:  Some items may not be completely removed by simply uninstalling the operator and instance.  For this a cleanup script has been provided in the cleanup directory of this repository.  Obtain a login token from the OpenShift instance then run the script:

`./mas-clean.sh <instance namespace> <bas namespace> <sls namespace> <mongo namespace>`

