## gitops-mas-core_uds_contact_email: The email address of the contact person for UDS
#gitops-mas-core_uds_contact_email=""

## gitops-mas-core_uds_contact_first_name: The first name of the contact person for UDS
#gitops-mas-core_uds_contact_first_name=""

## gitops-mas-core_uds_contact_last_name: The last name of the contact person for UDS
#gitops-mas-core_uds_contact_last_name=""

## gitops-mas-core_license_key: The contents of the license key that should be applied to the new instance. The value can be provided directly or via the 'license_key_file' variable. If none is provided the license will need to be applied manually after install.
#gitops-mas-core_license_key=""

## gitops-mas-core_license_key_file: The name of the file containing the license key that should be applied to the new instance. The value can be provided in a file or directly via the 'license_key' variable. If none is provided the license will need to be applied manually after install.
#gitops-mas-core_license_key_file=""

## gitops_repo_host: The host for the git repository. The git host used can be a GitHub, GitHub Enterprise, Gitlab, Bitbucket, Gitea or Azure DevOps server. If the host is null assumes in-cluster Gitea instance will be used.
#gitops_repo_host=""

## gitops_repo_org: The org/group where the git repository exists/will be provisioned. If the value is left blank then the username org will be used.
#gitops_repo_org=""

## gitops_repo_project: The project that will be used for the git repo. (Primarily used for Azure DevOps repos)
#gitops_repo_project=""

## gitops_repo_username: The username of the user with access to the repository
#gitops_repo_username=""

## gitops_repo_repo: The short name of the repository (i.e. the part after the org/group name)
#gitops_repo_repo=""

## server_url: The url for the OpenShift api
#server_url=""

## rwx_storage_class: The storage class to use for Read-Write-Many volumes
#rwx_storage_class=""

## rwo_storage_class: The storage class to use for Read-Write-One volumes
#rwo_storage_class=""

## file_storage_class: The storage class to use for File storage volumes
#file_storage_class=""

## block_storage_class: The storage class to use for Block storage volumes
#block_storage_class=""

