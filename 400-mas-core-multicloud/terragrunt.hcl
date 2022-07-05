include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode("${get_parent_terragrunt_dir()}/layers.yaml")

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

dependency "gitops" {
  config_path = local.gitops_config_path
  skip_outputs = local.gitops_skip_outputs
}

dependency "storage" {
  config_path = local.storage_config_path
  skip_outputs = local.storage_skip_outputs
}

terraform {
  extra_arguments "reduced_parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=3"]
  }
}
