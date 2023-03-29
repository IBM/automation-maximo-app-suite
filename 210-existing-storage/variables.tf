variable "storage_rwx_storage_class" {
  type = string
  description = "The storage class to use for Read-Write-Many volumes"
}
variable "storage_rwo_storage_class" {
  type = string
  description = "The storage class to use for Read-Write-One volumes"
}
variable "storage_file_storage_class" {
  type = string
  description = "The storage class to use for File storage volumes"
}
variable "storage_block_storage_class" {
  type = string
  description = "The storage class to use for Block storage volumes"
}
