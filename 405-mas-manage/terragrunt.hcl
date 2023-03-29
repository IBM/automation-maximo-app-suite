include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

  dep_200 = local.dependencies["200"].names[0]
  mock_200 = local.dependencies["200"].mock
  gitops_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_200}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_200}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_200}"
  gitops_skip_outputs = fileexists("${get_parent_terragrunt_dir()}/${local.dep_200}/terragrunt.hcl") ? false : true

  names_210 = local.dependencies["210"].names
  filtered_names_210 = [for dir in local.names_210 : "${get_parent_terragrunt_dir()}/${dir}" if fileexists("${get_parent_terragrunt_dir()}/${dir}/terragrunt.hcl")]
  storage_config_path = length(local.filtered_names_210) > 0 ? local.filtered_names_210[0] : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_210}"
  mock_210 = local.dependencies["210"].mock
  storage_skip_outputs = length(local.filtered_names_210) > 0 ? false : true
}

dependency "gitops" {
  config_path = local.gitops_config_path
  skip_outputs = local.gitops_skip_outputs

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan", "destroy", "output"]
  mock_outputs = {
    gitops_repo_config_host = ""
    gitops_repo_config_org = ""
    gitops_repo_config_name = ""
    gitops_repo_config_project = ""
    gitops_repo_config_username = ""
    gitops_repo_config_token = ""
  }
}

dependency "storage" {
  config_path = local.storage_config_path

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan", "destroy", "output"]
  mock_outputs = {
    storage_rwx_storage_class = ""
    storage_rwo_storage_class = ""
    storage_file_storage_class = ""
    storage_block_storage_class = ""
  }
}

dependency "mas-core" {
  config_path = "${get_parent_terragrunt_dir()}/400-mas-core"
  skip_outputs = false

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan", "destroy", "output"]
  mock_outputs = {
    gitops-mas-core_core_namespace = ""
    gitops-mas-core_entitlement_secret_name = ""
    gitops-mas-core_mas_instance_id = ""
    gitops-mas-core_mas_workspace_id = ""
  }
}

terraform {
  extra_arguments "reduced_parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=3"]
  }
}

inputs = {
  gitops_repo_host = dependency.gitops.outputs.gitops_repo_config_host
  gitops_repo_org = dependency.gitops.outputs.gitops_repo_config_org
  gitops_repo_repo = dependency.gitops.outputs.gitops_repo_config_name
  gitops_repo_project = dependency.gitops.outputs.gitops_repo_config_project
  gitops_repo_username = dependency.gitops.outputs.gitops_repo_config_username
  gitops_repo_token = dependency.gitops.outputs.gitops_repo_config_token

  rwx_storage_class = dependency.storage.outputs.storage_rwx_storage_class
  rwo_storage_class = dependency.storage.outputs.storage_rwo_storage_class
  file_storage_class = dependency.storage.outputs.storage_file_storage_class
  block_storage_class = dependency.storage.outputs.storage_block_storage_class

  mas_core_existing_core_namespace = dependency.mas-core.outputs.gitops-mas-core_core_namespace
  mas_core_existing_entitlement_secret_name = dependency.mas-core.outputs.gitops-mas-core_entitlement_secret_name
  mas_core_existing_mas_instance_id = dependency.mas-core.outputs.gitops-mas-core_mas_instance_id
  mas_core_existing_mas_workspace_id = dependency.mas-core.outputs.gitops-mas-core_mas_workspace_id
}
