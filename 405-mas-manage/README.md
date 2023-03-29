# 405-mas-manage

GitOps deployment of Maximo Manage application for OpenShift

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
| [gitops-mas-manage](https://github.com/cloud-native-toolkit/terraform-gitops-mas-manage) | Module to populate a gitops repo with the resources to provision Maximo-Applications | v2.1.1 |
| [gitops-repo](https://github.com/cloud-native-toolkit/terraform-tools-gitops) | Module to provision and set up a GitOps repository | v1.23.3 |
| [util-mas-core-existing](https://github.com/cloud-native-toolkit/terraform-util-mas-core-existing) | Module to represent an existing MAS Core install | v1.0.0 |
| [util-storage-class-manager](https://github.com/cloud-native-toolkit/terraform-util-storage-class-manager) | Module to collect and organize storage classes within a template | v1.0.3 |
| [util-clis](https://github.com/cloud-native-toolkit/terraform-util-clis) | Module to install clis into local bin directory | v1.19.0 |

### Variables

| Name | Description | Sensitive | Default value |
|------|-------------|-----------|---------------|
| gitops_repo_host | The host for the git repository. The git host used can be a GitHub, GitHub Enterprise, Gitlab, Bitbucket, Gitea or Azure DevOps server. If the host is null assumes in-cluster Gitea instance will be used. |  |  |
| gitops_repo_org | The org/group where the git repository exists/will be provisioned. If the value is left blank then the username org will be used. |  |  |
| gitops_repo_project | The project that will be used for the git repo. (Primarily used for Azure DevOps repos) |  |  |
| gitops_repo_username | The username of the user with access to the repository |  |  |
| gitops_repo_token | The personal access token used to access the repository | true |  |
| gitops_repo_repo | The short name of the repository (i.e. the part after the org/group name) |  |  |
| mas_core_existing_core_namespace | The namespace where the module will be deployed |  |  |
| mas_core_existing_entitlement_secret_name | The name of the secret that contains the entitlement_key |  |  |
| mas_core_existing_mas_instance_id | The identifier of the MAS instance that was created |  |  |
| mas_core_existing_mas_workspace_id | The identifier of the MAS workspace that was created |  |  |
| rwx_storage_class | The storage class to use for Read-Write-Many volumes |  |  |
| rwo_storage_class | The storage class to use for Read-Write-One volumes |  |  |
| file_storage_class | The storage class to use for File storage volumes |  |  |
| block_storage_class | The storage class to use for Block storage volumes |  |  |

## Troubleshooting

