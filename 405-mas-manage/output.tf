output "gitops-mas-manage_name" {
  description = "The name of the module"
  value = module.gitops-mas-manage.name
}
output "gitops-mas-manage_branch" {
  description = "The branch where the module config has been placed"
  value = module.gitops-mas-manage.branch
}
output "gitops-mas-manage_namespace" {
  description = "The namespace where the module will be deployed"
  value = module.gitops-mas-manage.namespace
}
output "gitops-mas-manage_server_name" {
  description = "The server where the module will be deployed"
  value = module.gitops-mas-manage.server_name
}
output "gitops-mas-manage_layer" {
  description = "The layer where the module is deployed"
  value = module.gitops-mas-manage.layer
}
output "gitops-mas-manage_type" {
  description = "The type of module where the module is deployed"
  value = module.gitops-mas-manage.type
}
output "gitops-mas-manage_mas_workspace_id" {
  description = "The id of the mas app workspace deployed"
  value = module.gitops-mas-manage.mas_workspace_id
}
output "gitops-mas-manage_mas_instance_id" {
  description = "The id of the mas instance deployed"
  value = module.gitops-mas-manage.mas_instance_id
}
output "gitops-mas-manage_mas_app_id" {
  description = "The name of the app (manage)"
  value = module.gitops-mas-manage.mas_app_id
}
output "gitops_repo_config_host" {
  description = "The host name of the bootstrap git repo"
  value = module.gitops_repo.config_host
}
output "gitops_repo_config_org" {
  description = "The org name of the bootstrap git repo"
  value = module.gitops_repo.config_org
}
output "gitops_repo_config_name" {
  description = "The repo name of the bootstrap git repo"
  value = module.gitops_repo.config_name
}
output "gitops_repo_config_project" {
  description = "The project name of the bootstrap git repo (for Azure DevOps)"
  value = module.gitops_repo.config_project
}
output "gitops_repo_config_repo" {
  description = "The repo that contains the argocd configuration"
  value = module.gitops_repo.config_repo
}
output "gitops_repo_config_repo_url" {
  description = "The repo that contains the argocd configuration"
  value = module.gitops_repo.config_repo_url
}
output "gitops_repo_config_ca_cert" {
  description = "The ca cert for the self-signed certificate used by the gitops repo"
  value = module.gitops_repo.config_ca_cert
}
output "gitops_repo_config_username" {
  description = "The username for the config repo"
  value = module.gitops_repo.config_username
}
output "gitops_repo_config_token" {
  description = "The token for the config repo"
  value = module.gitops_repo.config_token
  sensitive = true
}
output "gitops_repo_config_paths" {
  description = "The paths in the config repo"
  value = module.gitops_repo.config_paths
}
output "gitops_repo_config_projects" {
  description = "The ArgoCD projects for the different layers of the repo"
  value = module.gitops_repo.config_projects
}
output "gitops_repo_bootstrap_path" {
  description = "The path to the bootstrap configuration"
  value = module.gitops_repo.bootstrap_path
}
output "gitops_repo_bootstrap_branch" {
  description = "The branch in the gitrepo containing the bootstrap configuration"
  value = module.gitops_repo.bootstrap_branch
}
output "gitops_repo_application_repo" {
  description = "The repo that contains the application configuration"
  value = module.gitops_repo.application_repo
}
output "gitops_repo_application_repo_url" {
  description = "The repo that contains the application configuration"
  value = module.gitops_repo.application_repo_url
}
output "gitops_repo_application_username" {
  description = "The username for the application repo"
  value = module.gitops_repo.application_username
}
output "gitops_repo_application_token" {
  description = "The token for the application repo"
  value = module.gitops_repo.application_token
  sensitive = true
}
output "gitops_repo_application_paths" {
  description = "The paths in the application repo"
  value = module.gitops_repo.application_paths
}
output "gitops_repo_gitops_config" {
  description = "Config information regarding the gitops repo structure"
  value = module.gitops_repo.gitops_config
}
output "gitops_repo_git_credentials" {
  description = "The credentials for the gitops repo(s)"
  value = module.gitops_repo.git_credentials
  sensitive = true
}
output "gitops_repo_server_name" {
  description = "The name of the cluster that will be configured for gitops"
  value = module.gitops_repo.server_name
}
output "gitops_repo_sealed_secrets_cert" {
  description = "The certificate used to encrypt sealed secrets"
  value = module.gitops_repo.sealed_secrets_cert
}
output "mas_core_existing_core_namespace" {
  description = "The namespace where the module will be deployed"
  value = module.mas_core_existing.core_namespace
}
output "mas_core_existing_entitlement_secret_name" {
  description = "The name of the secret that contains the entitlement_key"
  value = module.mas_core_existing.entitlement_secret_name
}
output "mas_core_existing_mas_instance_id" {
  description = "The identifier of the MAS instance that was created"
  value = module.mas_core_existing.mas_instance_id
}
output "mas_core_existing_mas_workspace_id" {
  description = "The identifier of the MAS workspace that was created"
  value = module.mas_core_existing.mas_workspace_id
}
output "util-storage-class-manager_rwx_storage_class" {
  description = "The storage class to use for Read-Write-Many volumes"
  value = module.util-storage-class-manager.rwx_storage_class
}
output "util-storage-class-manager_rwo_storage_class" {
  description = "The storage class to use for Read-Write-One volumes"
  value = module.util-storage-class-manager.rwo_storage_class
}
output "util-storage-class-manager_file_storage_class" {
  description = "The storage class to use for File storage volumes"
  value = module.util-storage-class-manager.file_storage_class
}
output "util-storage-class-manager_block_storage_class" {
  description = "The storage class to use for Block storage volumess"
  value = module.util-storage-class-manager.block_storage_class
}
output "util-clis_bin_dir" {
  description = "Directory where the clis were downloaded"
  value = module.util-clis.bin_dir
}
