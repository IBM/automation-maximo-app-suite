include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

  names_105 = local.dependencies.names_105
  filtered_names_105 = [for dir in local.names_105 : "${get_parent_terragrunt_dir()}/${dir}" if fileexists("${get_parent_terragrunt_dir()}/${dir}/terragrunt.hcl")]
  cluster_config_path = length(local.filtered_names_105) > 0 ? local.filtered_names_105[0] : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_105}"
  mock_105 = local.dependencies.mock_105

  dep_200 = local.dependencies.name_200
  mock_200 = local.dependencies.mock_200
  gitops_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_200}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_200}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_200}"
  gitops_skip_outputs = fileexists("${get_parent_terragrunt_dir()}/${local.dep_200}/terragrunt.hcl") ? false : true

  names_210 = local.dependencies.names_210
  filtered_names_210 = [for dir in local.names_210 : "${get_parent_terragrunt_dir()}/${dir}" if fileexists("${get_parent_terragrunt_dir()}/${dir}/terragrunt.hcl")]
  storage_config_path = length(local.filtered_names_210) > 0 ? local.filtered_names_210[0] : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_210}"
  mock_210 = local.dependencies.mock_210
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
    cluster_ingress = ""
  }
}

dependency "gitops" {
  config_path = local.gitops_config_path
  skip_outputs = local.gitops_skip_outputs

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan", "destroy", "output"]
  mock_outputs = {
    gitops_host = ""
    gitops_org = ""
    gitops_name = ""
    gitops_project = ""
    gitops_username = ""
    gitops_token = ""
  }
}

dependency "storage" {
  config_path = local.storage_config_path
  skip_outputs = true

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan", "destroy", "output"]
  mock_outputs = {
  }
}

terraform {
  extra_arguments "reduced_parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=3"]
  }
}

inputs = {
  cluster_ingress = dependency.cluster.outputs.cluster_ingress
  gitops_repo_host = dependency.gitops.outputs.gitops_host
  gitops_repo_org = dependency.gitops.outputs.gitops_org
  gitops_repo_repo = dependency.gitops.outputs.gitops_name
  gitops_repo_project = dependency.gitops.outputs.gitops_project
  gitops_repo_username = dependency.gitops.outputs.gitops_username
  gitops_repo_token = dependency.gitops.outputs.gitops_token
}
