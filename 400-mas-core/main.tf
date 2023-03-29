module "cluster" {
  source = "github.com/cloud-native-toolkit/terraform-ocp-login?ref=v1.6.2"

  ca_cert = var.cluster_ca_cert
  ca_cert_file = var.cluster_ca_cert_file
  cluster_version = var.cluster_cluster_version
  ingress_subdomain = var.cluster_ingress_subdomain
  login_password = var.cluster_login_password
  login_token = var.cluster_login_token
  login_user = var.cluster_login_user
  server_url = var.server_url
  skip = var.cluster_skip
  tls_secret_name = var.cluster_tls_secret_name
}
module "gitea" {
  source = "github.com/cloud-native-toolkit/terraform-tools-gitea?ref=v0.5.1"

  ca_cert = module.cluster.ca_cert
  ca_cert_file = var.gitea_ca_cert_file
  cluster_config_file = module.cluster.config_file_path
  cluster_type = module.cluster.platform.type_code
  instance_name = var.gitea_instance_name
  instance_namespace = module.gitea_namespace.name
  olm_namespace = module.olm.olm_namespace
  operator_namespace = module.olm.target_namespace
  password = var.gitea_password
  username = var.gitea_username
}
module "gitea_namespace" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-namespace?ref=v3.2.4"

  cluster_config_file_path = module.cluster.config_file_path
  create_operator_group = var.gitea_namespace_create_operator_group
  name = var.gitea_namespace_name
}
module "gitops_repo" {
  source = "github.com/cloud-native-toolkit/terraform-tools-gitops?ref=v1.23.3"

  branch = var.gitops_repo_branch
  debug = var.debug
  gitea_host = module.gitea.host
  gitea_org = module.gitea.org
  gitea_token = module.gitea.token
  gitea_username = module.gitea.username
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
module "gitops-mas-core" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-mas-core?ref=v1.2.0"

  catalog_name = module.gitops-toolkit-catalog.name
  entitlement_key = var.entitlement_key
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  host_id = var.gitops-mas-core_host_id
  kubeseal_cert = module.gitops_repo.sealed_secrets_cert
  license_key = var.gitops-mas-core_license_key
  license_key_file = var.gitops-mas-core_license_key_file
  mas_channel = var.gitops-mas-core_mas_channel
  mas_instance_id = var.gitops-mas-core_mas_instance_id
  mas_workspace_id = var.gitops-mas-core_mas_workspace_id
  mas_workspace_name = var.gitops-mas-core_mas_workspace_name
  mongodb_storage_class = module.util-storage-class-manager.block_storage_class
  server_name = module.gitops_repo.server_name
  uds_contact_email = var.gitops-mas-core_uds_contact_email
  uds_contact_first_name = var.gitops-mas-core_uds_contact_first_name
  uds_contact_last_name = var.gitops-mas-core_uds_contact_last_name
  uds_storage_class = module.util-storage-class-manager.block_storage_class
}
module "gitops-toolkit-catalog" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-toolkit-catalog?ref=v1.0.0"

  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  server_name = module.gitops_repo.server_name
}
module "olm" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-olm?ref=v1.3.5"

  cluster_config_file = module.cluster.config_file_path
  cluster_type = module.cluster.platform.type_code
  cluster_version = module.cluster.platform.version
}
module "util-clis" {
  source = "cloud-native-toolkit/clis/util"
  version = "1.19.0"

  bin_dir = var.util-clis_bin_dir
  clis = var.util-clis_clis == null ? null : jsondecode(var.util-clis_clis)
}
module "util-mas-core-ready" {
  source = "github.com/cloud-native-toolkit/terraform-util-mas-core-ready?ref=v1.1.1"

  cluster_config_file = module.cluster.config_file_path
  core_namespace = module.gitops-mas-core.core_namespace
  entitlement_secret_name = module.gitops-mas-core.entitlement_secret_name
  mas_instance_id = module.gitops-mas-core.mas_instance_id
  mas_workspace_id = module.gitops-mas-core.mas_workspace_id
}
module "util-storage-class-manager" {
  source = "github.com/cloud-native-toolkit/terraform-util-storage-class-manager?ref=v1.0.3"

  block_storage_class = var.block_storage_class
  file_storage_class = var.file_storage_class
  rwo_storage_class = var.rwo_storage_class
  rwx_storage_class = var.rwx_storage_class
}
