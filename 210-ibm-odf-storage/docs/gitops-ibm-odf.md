# ibm-odf module

Module to populate a gitops repo with the resources to provision ibm-ocs using the OpenShift Data Foundation add-on for ROKS clusters.


## Software dependencies

The module depends on the following software components:

### Terraform version

- \>= v0.15

### Terraform providers


- gitops (cloud-native-toolkit/gitops)

### Module dependencies


- gitops - [github.com/cloud-native-toolkit/terraform-tools-gitops.git](https://github.com/cloud-native-toolkit/terraform-tools-gitops.git) (>= 1.1.0)
- namespace - [github.com/cloud-native-toolkit/terraform-gitops-namespace.git](https://github.com/cloud-native-toolkit/terraform-gitops-namespace.git) (>= 1.0.0)

## Example usage

```hcl
module "gitops-ibm-odf" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-ibm-odf"

  autoDiscoverDevices = var.gitops-ibm-odf_autoDiscoverDevices
  billingType = var.gitops-ibm-odf_billingType
  clusterEncryption = var.gitops-ibm-odf_clusterEncryption
  default_block_storage_class = var.gitops-ibm-odf_default_block_storage_class
  default_file_storage_class = var.gitops-ibm-odf_default_file_storage_class
  default_rwo_storage_class = var.gitops-ibm-odf_default_rwo_storage_class
  default_rwx_storage_class = var.gitops-ibm-odf_default_rwx_storage_class
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  hpcsBaseUrl = var.gitops-ibm-odf_hpcsBaseUrl
  hpcsEncryption = var.gitops-ibm-odf_hpcsEncryption
  hpcsInstanceId = var.gitops-ibm-odf_hpcsInstanceId
  hpcsSecretName = var.gitops-ibm-odf_hpcsSecretName
  hpcsServiceName = var.gitops-ibm-odf_hpcsServiceName
  hpcsTokenUrl = var.gitops-ibm-odf_hpcsTokenUrl
  ibmcloud_api_key = var.ibmcloud_api_key
  kubeseal_cert = module.gitops_repo.sealed_secrets_cert
  monDevicePaths = var.gitops-ibm-odf_monDevicePaths
  monSize = var.gitops-ibm-odf_monSize
  monStorageClassName = var.gitops-ibm-odf_monStorageClassName
  namespace = module.odf_namespace.name
  numOfOsd = var.gitops-ibm-odf_numOfOsd
  ocsUpgrade = var.gitops-ibm-odf_ocsUpgrade
  osdDevicePaths = var.gitops-ibm-odf_osdDevicePaths
  osdSize = var.gitops-ibm-odf_osdSize
  osdStorageClassName = var.gitops-ibm-odf_osdStorageClassName
  server_name = module.gitops_repo.server_name
  workerNodes = var.gitops-ibm-odf_workerNodes
}

```

## Module details

### Inputs

| Name | Description | Required | Default | Source |
|------|-------------|---------|----------|--------|
| gitops_config | Config information regarding the gitops repo structure | true |  | gitops.gitops_config |
| git_credentials | The credentials for the gitops repo(s) | true |  | gitops.git_credentials |
| namespace | The namespace where the application should be deployed | true |  | namespace.name |
| kubeseal_cert | The certificate/public key used to encrypt the sealed secrets | true |  | gitops.sealed_secrets_cert |
| server_name | The name of the server | false | default | gitops.server_name |
| ibmcloud_api_key | The api key for IBM Cloud access | true |  |  |
| osdStorageClassName | Storage class that you want to use for your OSD devices | false | ibmc-vpc-block-metro-10iops-tier |  |
| osdDevicePaths | Please provide IDs of the disks to be used for OSD pods if using local disks or standard classic cluster | true |  |  |
| osdSize | Size of your storage devices. The total storage capacity of your ODF cluster is equivalent to the osdSize x 3 divided by the numOfOsd. | false | 250Gi |  |
| numOfOsd | Number object storage daemons (OSDs) that you want to create. ODF creates three times the numOfOsd value. | false | "1" |  |
| billingType | Billing Type for your ODF deployment (`essentials` or `advanced`). | false | advanced |  |
| ocsUpgrade | Whether to upgrade the major version of your ODF deployment. | false | "false" |  |
| clusterEncryption | Enable encryption of storage cluster | false | "false" |  |
| workerNodes | Install on which worker nodes | false | all |  |
| monSize | Size of the storage devices that you want to provision for the monitor pods. The devices must be at least 20Gi each | false | 20Gi |  |
| monStorageClassName | Storage class to use for your Monitor pods. For VPC clusters you must specify a block storage class | false | ibmc-vpc-block-metro-10iops-tier |  |
| monDevicePaths | Please provide IDs of the disks to be used for mon pods if using local disks or standard classic cluster | true |  |  |
| autoDiscoverDevices | Auto Discover Devices | false | false |  |
| hpcsEncryption | Use Hyper Protect Crypto Services | false | "false" |  |
| hpcsServiceName | Enter the name of your Hyper Protect Crypto Services instance. For example: Hyper-Protect-Crypto-Services-eugb | false | false |  |
| hpcsInstanceId | Enter your Hyper Protect Crypto Services instance ID. For example: d11a1a43-aa0a-40a3-aaa9-5aaa63147aaa | false | false |  |
| hpcsSecretName | Enter the name of the secret that you created by using your Hyper Protect Crypto Services credentials. For example: ibm-hpcs-secret | false | false |  |
| hpcsBaseUrl | Enter the public endpoint of your Hyper Protect Crypto Services instance. For example: https://api.eu-gb.hs-crypto.cloud.ibm.com:8389 | false | false |  |
| hpcsTokenUrl | Enter https://iam.cloud.ibm.com/oidc/token | false | false |  |
| default_rwx_storage_class | The default storage class that should be used for RWX volumes | false | ocs-storagecluster-cephfs |  |
| default_rwo_storage_class | The default storage class that should be used for RWO volumes | false | ocs-storagecluster-ceph-rbd |  |
| default_file_storage_class | The default storage class that should be used for file volumes | false | ocs-storagecluster-cephfs |  |
| default_block_storage_class | The default storage class that should be used for block volumes | false | ibmc-vpc-block-10iops-tier |  |

### Outputs

| Name | Description |
|------|-------------|
| name | The name of the module |
| branch | The branch where the module config has been placed |
| namespace | The namespace where the module will be deployed |
| server_name | The server where the module will be deployed |
| layer | The layer where the module is deployed |
| type | The type of module where the module is deployed |
| rwx_storage_class |  |
| rwo_storage_class |  |
| file_storage_class |  |
| block_storage_class |  |
| storage_classes_provided |  |

## Resources

- [Documentation](https://operate.cloudnativetoolkit.dev)
- [Module catalog](https://modules.cloudnativetoolkit.dev)

> License: Apache License 2.0 | Generated by iascable (3.2.2)
