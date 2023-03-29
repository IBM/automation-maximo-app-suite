output "storage_rwx_storage_class" {
  description = "The storage class to use for Read-Write-Many volumes"
  value = module.storage.rwx_storage_class
}
output "storage_rwo_storage_class" {
  description = "The storage class to use for Read-Write-One volumes"
  value = module.storage.rwo_storage_class
}
output "storage_file_storage_class" {
  description = "The storage class to use for File storage volumes"
  value = module.storage.file_storage_class
}
output "storage_block_storage_class" {
  description = "The storage class to use for Block storage volumess"
  value = module.storage.block_storage_class
}
