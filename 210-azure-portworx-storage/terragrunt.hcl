include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode("${get_parent_terragrunt_dir()}/layers.yaml")
  dep_200 = local.dependencies.name_200
  mock_200 = local.dependencies.mock_200
}

dependency "gitops" {
  config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_200}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_200}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_200}"
  skip_outputs = fileexists("${get_parent_terragrunt_dir()}/${local.dep_200}/terragrunt.hcl") ? false : true
}
