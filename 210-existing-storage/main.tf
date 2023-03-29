module "storage" {
  source = "github.com/cloud-native-toolkit/terraform-util-storage-class-manager?ref=v1.0.3"

  block_storage_class = var.storage_block_storage_class
  file_storage_class = var.storage_file_storage_class
  rwo_storage_class = var.storage_rwo_storage_class
  rwx_storage_class = var.storage_rwx_storage_class
}
