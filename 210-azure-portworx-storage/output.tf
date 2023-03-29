output "azure-portworx_default_rwx_storage_class" {
  description = "Default read-write-many storage class"
  value = module.azure-portworx.default_rwx_storage_class
}
output "azure-portworx_rwx_storage_class" {
  description = "the value of azure-portworx_rwx_storage_class"
  value = module.azure-portworx.rwx_storage_class
}
output "azure-portworx_rwo_storage_class" {
  description = "the value of azure-portworx_rwo_storage_class"
  value = module.azure-portworx.rwo_storage_class
}
output "azure-portworx_file_storage_class" {
  description = "the value of azure-portworx_file_storage_class"
  value = module.azure-portworx.file_storage_class
}
output "azure-portworx_block_storage_class" {
  description = "the value of azure-portworx_block_storage_class"
  value = module.azure-portworx.block_storage_class
}
output "azure-portworx_storage_classes_provided" {
  description = "the value of azure-portworx_storage_classes_provided"
  value = module.azure-portworx.storage_classes_provided
}
output "cluster_id" {
  description = "ID of the cluster."
  value = module.cluster.id
}
output "cluster_ocp_id" {
  description = "OpenShift ID of the cluster."
  value = module.cluster.ocp_id
}
output "cluster_name" {
  description = "Name of the cluster"
  value = module.cluster.name
}
output "cluster_region" {
  description = "Region of the cluster"
  value = module.cluster.region
}
output "cluster_resource_group_name" {
  description = "Resource group of the cluster"
  value = module.cluster.resource_group_name
}
output "cluster_server_url" {
  description = "The url of the control server."
  value = module.cluster.server_url
}
output "cluster_username" {
  description = "The username of the control server."
  value = module.cluster.username
}
output "cluster_password" {
  description = "The password of the control server."
  value = module.cluster.password
  sensitive = true
}
output "cluster_token" {
  description = "The token of the control server."
  value = module.cluster.token
  sensitive = true
}
output "cluster_config_file_path" {
  description = "Path to the config file for the cluster."
  value = module.cluster.config_file_path
}
output "cluster_platform" {
  description = "Configuration values for the cluster platform"
  value = module.cluster.platform
}
output "cluster_ca_cert" {
  description = "Base64 encoded CA certificate for cluster endpoints"
  value = module.cluster.ca_cert
}
