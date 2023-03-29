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

## mas_core_existing_core_namespace: The namespace where the module will be deployed
#mas_core_existing_core_namespace=""

## mas_core_existing_entitlement_secret_name: The name of the secret that contains the entitlement_key
#mas_core_existing_entitlement_secret_name=""

## mas_core_existing_mas_instance_id: The identifier of the MAS instance that was created
#mas_core_existing_mas_instance_id=""

## mas_core_existing_mas_workspace_id: The identifier of the MAS workspace that was created
#mas_core_existing_mas_workspace_id=""

## rwx_storage_class: The storage class to use for Read-Write-Many volumes
#rwx_storage_class=""

## rwo_storage_class: The storage class to use for Read-Write-One volumes
#rwo_storage_class=""

## file_storage_class: The storage class to use for File storage volumes
#file_storage_class=""

## block_storage_class: The storage class to use for Block storage volumes
#block_storage_class=""

