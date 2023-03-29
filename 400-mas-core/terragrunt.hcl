include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

  names_105 = local.dependencies["cluster"].names
  filtered_names_105 = [for dir in local.names_105 : "${get_parent_terragrunt_dir()}/${dir}" if fileexists("${get_parent_terragrunt_dir()}/${dir}/terragrunt.hcl")]
  cluster_config_path = length(local.filtered_names_105) > 0 ? local.filtered_names_105[0] : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_105}"
  mock_105 = local.dependencies["cluster"].mock

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

dependency "cluster" {
  config_path = local.cluster_config_path
  skip_outputs = false

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan", "destroy", "output"]
  mock_outputs = {
    cluster_server_url = ""
    cluster_username = ""
    cluster_password = ""
    cluster_token = ""
  }
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

terraform {
  extra_arguments "reduced_parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=3"]
  }
}

inputs = {
  server_url = dependency.cluster.outputs.cluster_server_url
  cluster_server_url = dependency.cluster.outputs.cluster_server_url
  cluster_login_user = dependency.cluster.outputs.cluster_username
  cluster_login_password = dependency.cluster.outputs.cluster_password
  cluster_login_token = dependency.cluster.outputs.cluster_token

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
}
