module "gitops_repo" {
  source = "github.com/cloud-native-toolkit/terraform-tools-gitops?ref=v1.23.3"

  branch = var.gitops_repo_branch
  debug = var.debug
  gitea_host = var.gitops_repo_gitea_host
  gitea_org = var.gitops_repo_gitea_org
  gitea_token = var.gitops_repo_gitea_token
  gitea_username = var.gitops_repo_gitea_username
  gitops_namespace = var.gitops_repo_gitops_namespace
  host = var.gitops_repo_host
  org = var.gitops_repo_org
  project = var.gitops_repo_project
  public = var.gitops_repo_public
  repo = var.gitops_repo_repo
  sealed_secrets_cert = var.gitops_repo_sealed_secrets_cert
  server_name = var.gitops_repo_server_name
  strict = var.gitops_repo_strict
  token = var.gitops_repo_token
  type = var.gitops_repo_type
  username = var.gitops_repo_username
}
module "gitops-mas-manage" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-mas-manage?ref=v2.1.1"

  core_namespace = module.mas_core_existing.core_namespace
  db2_data_storage_class = module.util-storage-class-manager.block_storage_class
  db2_dbname = var.gitops-mas-manage_db2_dbname
  db2_instance_name = var.gitops-mas-manage_db2_instance_name
  db2_meta_storage_class = module.util-storage-class-manager.rwx_storage_class
  demodata = var.gitops-mas-manage_demodata
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  ibm_entitlement_secret = module.mas_core_existing.entitlement_secret_name
  kubeseal_cert = module.gitops_repo.sealed_secrets_cert
  mas_app_channel = var.gitops-mas-manage_mas_app_channel
  mas_config_scope = var.gitops-mas-manage_mas_config_scope
  mas_instance_id = module.mas_core_existing.mas_instance_id
  mas_workspace_id = module.mas_core_existing.mas_workspace_id
  server_name = module.gitops_repo.server_name
}
module "mas_core_existing" {
  source = "github.com/cloud-native-toolkit/terraform-util-mas-core-existing?ref=v1.0.0"

  core_namespace = var.mas_core_existing_core_namespace
  entitlement_secret_name = var.mas_core_existing_entitlement_secret_name
  mas_instance_id = var.mas_core_existing_mas_instance_id
  mas_workspace_id = var.mas_core_existing_mas_workspace_id
}
module "util-clis" {
  source = "cloud-native-toolkit/clis/util"
  version = "1.19.0"

  bin_dir = var.util-clis_bin_dir
  clis = var.util-clis_clis == null ? null : jsondecode(var.util-clis_clis)
}
module "util-storage-class-manager" {
  source = "github.com/cloud-native-toolkit/terraform-util-storage-class-manager?ref=v1.0.3"

  block_storage_class = var.block_storage_class
  file_storage_class = var.file_storage_class
  rwo_storage_class = var.rwo_storage_class
  rwx_storage_class = var.rwx_storage_class
}
