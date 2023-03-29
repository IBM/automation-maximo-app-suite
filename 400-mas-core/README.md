# 400-mas-core

GitOps deployment of Maximo Application Suite Core for OpenShift

## Running the automation

There are three different options for how to configure and run the automation:

- Interactive prompts
- Yaml configuration
- Terraform configuration

### Interactive prompts

In this mode, you will be prompted interactively for the variables required to run the automation.

1. Run the `apply.sh` script
2. At each prompt, provide a value for the variable.
3. Once all the variables are collected, you will be asked to apply the automation. Enter `y` to continue or `n` to stop. Either way, the values provided have been collected and written to two sets of files so that next time you can skip the prompts.

The `apply.sh` script will generate credentials.yaml and variables.yaml input files that can be used
for future deployments as well as generating the credentials.auto.tfvars and terraform.tfvars files
used by the terraform. The variables.yaml and terraform.tfvars files can be checked in with the terraform
templates. However, credentials.yaml and credentials.auto.tfvars should be excluded since they contain
sensitive information. Those files should already be included in the .gitignore file.

### Yaml configuration

In this mode, you provide the configuration for your instance in yaml configuration files and avoid
the prompts.

1. Copy the variables.template.yaml file to variables.yaml and credentials.template.yaml to credentials.yaml.
2. Provide values for each of the variables in variables.yaml and credentials.yaml.
3. Run `apply.sh --ci` to kick off the automation. You will not be prompted for input variables and the automation will start immediately

The `apply.sh` script will generate the credentials.auto.tfvars and terraform.tfvars files from the
values provided in the yaml files. The variables.yaml and terraform.tfvars files can be checked in with the terraform
templates. However, credentials.yaml and credentials.auto.tfvars should be excluded since they contain
sensitive information. Those files should already be included in the .gitignore file.

### Terraform configuration

In situations where you are comfortable working with the terraform directly, you can skip the yaml
configuration files and directly configure the automation with the terraform configuration files.

1. Copy the variables.template.tfvars file and credentials.auto.template.tfvars to variables.tfvars and credentials.auto.tfvars, respectively.
2. Provide values for the different variables in variables.tfvars and credentials.auto.tfvars.
3. Kick off the automation with `apply.sh --ci` or skip the script and run `terragrunt run-all apply --terragrunt-parallelism 1 --terragrunt-non-interactive`

The terraform.tfvars file can be checked in with the terraform templates. However, credentials.auto.tfvars
should be excluded since it contains sensitive information. The credentials.auto.tfvars file should
already be in .gitignore.

## Contents

### Modules

| Name | Description | Version |
|------|-------------|---------|
| [gitea](https://github.com/cloud-native-toolkit/terraform-tools-gitea) | Module to install Gitea into a cluster via an operator | v0.5.1 |
| [gitops-mas-core](https://github.com/cloud-native-toolkit/terraform-gitops-mas-core) | Module to populate a gitops repo with the resources to provision Maximo Application Suite Core | v1.2.0 |
| [gitops-namespace](https://github.com/cloud-native-toolkit/terraform-gitops-namespace) | Module to configure the provisioning of a namespace in a GitOps repo | v1.15.0 |
| [gitops-repo](https://github.com/cloud-native-toolkit/terraform-tools-gitops) | Module to provision and set up a GitOps repository | v1.23.3 |
| [ocp-login](https://github.com/cloud-native-toolkit/terraform-ocp-login) | Module to perform a simple cluster login and provide the cluster path | v1.6.2 |
| [util-mas-core-ready](https://github.com/cloud-native-toolkit/terraform-util-mas-core-ready) | Module to wait for MAS Core (gitops) instance to be ready in the cluster | v1.1.1 |
| [util-storage-class-manager](https://github.com/cloud-native-toolkit/terraform-util-storage-class-manager) | Module to collect and organize storage classes within a template | v1.0.3 |
| [olm](https://github.com/cloud-native-toolkit/terraform-k8s-olm) | Installs Operator Lifecycle Manager in the cluster | v1.3.5 |
| [gitops-namespace](https://github.com/cloud-native-toolkit/terraform-gitops-namespace) | Module to configure the provisioning of a namespace in a GitOps repo | v3.2.4 |
| [gitops-toolkit-catalog](https://github.com/cloud-native-toolkit/terraform-gitops-toolkit-catalog) | Module to populate a gitops repo with the resources to provision the Toolkit operator catalog in a cluster. | v1.0.0 |
| [util-clis](https://github.com/cloud-native-toolkit/terraform-util-clis) | Module to install clis into local bin directory | v1.19.0 |

### Variables

| Name | Description | Sensitive | Default value |
|------|-------------|-----------|---------------|
| entitlement_key | The entitlement key used to access the Maximo Application Suite images in the container registry. Visit https://myibm.ibm.com/products-services/containerlibrary to get the key | true |  |
| gitops-mas-core_uds_contact_email | The email address of the contact person for UDS |  |  |
| gitops-mas-core_uds_contact_first_name | The first name of the contact person for UDS |  |  |
| gitops-mas-core_uds_contact_last_name | The last name of the contact person for UDS |  |  |
| gitops-mas-core_license_key | The contents of the license key that should be applied to the new instance. The value can be provided directly or via the 'license_key_file' variable. If none is provided the license will need to be applied manually after install. |  |  |
| gitops-mas-core_license_key_file | The name of the file containing the license key that should be applied to the new instance. The value can be provided in a file or directly via the 'license_key' variable. If none is provided the license will need to be applied manually after install. |  |  |
| gitops_repo_host | The host for the git repository. The git host used can be a GitHub, GitHub Enterprise, Gitlab, Bitbucket, Gitea or Azure DevOps server. If the host is null assumes in-cluster Gitea instance will be used. |  |  |
| gitops_repo_org | The org/group where the git repository exists/will be provisioned. If the value is left blank then the username org will be used. |  |  |
| gitops_repo_project | The project that will be used for the git repo. (Primarily used for Azure DevOps repos) |  |  |
| gitops_repo_username | The username of the user with access to the repository |  |  |
| gitops_repo_token | The personal access token used to access the repository | true |  |
| gitops_repo_repo | The short name of the repository (i.e. the part after the org/group name) |  |  |
| server_url | The url for the OpenShift api |  |  |
| cluster_login_token | Token used for authentication | true |  |
| rwx_storage_class | The storage class to use for Read-Write-Many volumes |  |  |
| rwo_storage_class | The storage class to use for Read-Write-One volumes |  |  |
| file_storage_class | The storage class to use for File storage volumes |  |  |
| block_storage_class | The storage class to use for Block storage volumes |  |  |

## Troubleshooting

