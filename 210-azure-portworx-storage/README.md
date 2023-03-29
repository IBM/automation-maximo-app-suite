# 210-azure-portworx-storage

Installs Portworx into an OCP cluster on Azure

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
| [azure-portworx](https://github.com/cloud-native-toolkit/terraform-azure-portworx) | Module to provision portworx on azure | v1.1.0 |
| [ocp-login](https://github.com/cloud-native-toolkit/terraform-ocp-login) | Module to perform a simple cluster login and provide the cluster path | v1.6.2 |

### Variables

| Name | Description | Sensitive | Default value |
|------|-------------|-----------|---------------|
| azure_subscription_id | The subscription id of the Azure account where the OpenShift cluster has been provisioned |  |  |
| azure_tenant_id | The tenant id of the Azure account where the OpenShift cluster has been provisioned |  |  |
| azure_client_id | The client id used to access the Azure account |  |  |
| azure_client_secret | The client secret used to access the Azure account |  |  |
| portworx_spec_file | The path to the file that contains the yaml spec for the Portworx config. Either the `portworx_spec_file` or `portworx_spec` must be provided. The instructions for creating this configuration can be found at https://github.com/cloud-native-toolkit/terraform-azure-portworx/blob/main/PORTWORX_CONFIG.md |  |  |
| portworx_spec | The yaml spec for the Portworx config. Either the `portworx_spec_file` or `portworx_spec` must be provided. The instructions for creating this configuration can be found at https://github.com/cloud-native-toolkit/terraform-azure-portworx/blob/main/PORTWORX_CONFIG.md |  |  |
| azure-portworx_enable_encryption | Flag indicating portworx volumes should be encrypted |  | false |
| server_url | The url for the OpenShift api |  |  |
| cluster_login_token | Token used for authentication | true |  |

## Troubleshooting

