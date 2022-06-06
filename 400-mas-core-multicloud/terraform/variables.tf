variable "bas_dbuser" {
  type = string
  description = "The (mongodb) database user"
  default = "dbuser"
}
variable "bas_dbpassword" {
  type = string
  description = "The value that will be used for the mongodb database password. If not provided, a random value will be generated."
  default = ""
}
variable "bas_grafanauser" {
  type = string
  description = "The grafana user"
  default = "gfuser"
}
variable "bas_grafanapassword" {
  type = string
  description = "The value that will be used for the grafana password. If not provided, a random value will be generated."
  default = ""
}
variable "gitops-cp-catalogs_namespace" {
  type = string
  description = "The namespace where the application should be deployed"
  default = "openshift-marketplace"
}
variable "entitlement_key" {
  type = string
  description = "The entitlement key used to access the CP4I images in the container registry. Visit https://myibm.ibm.com/products-services/containerlibrary to get the key"
}
variable "cluster_ingress" {
  type = string
  description = "Ingress for cluster"
}
variable "gitops-cp-maximo_instanceid" {
  type = string
  description = "instance name for to use for MAS Suite"
  default = "masdemo"
}
variable "gitops-cp-maximo_versionid" {
  type = string
  description = "version for MAS - this must match the update channel: 8.x for latest"
  default = "8.x"
}
variable "gitops-cp-maximo_installPlan" {
  type = string
  description = "Install Plan for App"
  default = "Automatic"
}
variable "gitops-cp-maximo_catalog_namespace" {
  type = string
  description = "Catalog source namespace"
  default = "openshift-marketplace"
}
variable "gitops-cp-maximo_certmgr_namespace" {
  type = string
  description = "Namespace of the cert-manager: should stay default value unless using another cert manager"
  default = "ibm-common-services"
}
variable "sls_catalog_namespace" {
  type = string
  description = "The namespace where the catalog has been deployed"
  default = "openshift-marketplace"
}
variable "sls_channel" {
  type = string
  description = "The channel that should be used to deploy the operator"
  default = "3.x"
}
variable "gitops-mongo-ce-operator_mongo_serviceaccount" {
  type = string
  description = "Name of the service account to use for mongo"
  default = "mongodb-kubernetes-operator"
}
variable "gitops-mongo-ce_password" {
  type = string
  description = "The database password"
  default = "password"
}
variable "gitops-mongo-ce_port" {
  type = string
  description = "The port to use for database"
  default = "27017"
}
variable "gitops-mongo-ce_mongo_version" {
  type = string
  description = "version for mongodb to be installed"
  default = "4.2.6"
}
variable "gitops-mongo-ce_replicaset_count" {
  type = string
  description = "No of pods to be created as part of replicaset"
  default = "3"
}
variable "gitops-mongo-ce_service_name" {
  type = string
  description = "Mongo svcname"
  default = "mongo-ce"
}
variable "sls-namespace_name" {
  type = string
  description = "The value that should be used for the namespace"
  default = "ibm-sls"
}
variable "sls-namespace_ci" {
  type = bool
  description = "Flag indicating that this namespace will be used for development (e.g. configmaps and secrets)"
  default = false
}
variable "sls-namespace_create_operator_group" {
  type = bool
  description = "Flag indicating that an operator group should be created in the namespace"
  default = true
}
variable "sls-namespace_argocd_namespace" {
  type = string
  description = "The namespace where argocd has been deployed"
  default = "openshift-gitops"
}
variable "mongo-namespace_name" {
  type = string
  description = "The value that should be used for the namespace"
  default = "mongo"
}
variable "mongo-namespace_ci" {
  type = bool
  description = "Flag indicating that this namespace will be used for development (e.g. configmaps and secrets)"
  default = false
}
variable "mongo-namespace_create_operator_group" {
  type = bool
  description = "Flag indicating that an operator group should be created in the namespace"
  default = true
}
variable "mongo-namespace_argocd_namespace" {
  type = string
  description = "The namespace where argocd has been deployed"
  default = "openshift-gitops"
}
variable "bas-namespace_name" {
  type = string
  description = "The value that should be used for the namespace"
  default = "masbas"
}
variable "bas-namespace_ci" {
  type = bool
  description = "Flag indicating that this namespace will be used for development (e.g. configmaps and secrets)"
  default = false
}
variable "bas-namespace_create_operator_group" {
  type = bool
  description = "Flag indicating that an operator group should be created in the namespace"
  default = true
}
variable "bas-namespace_argocd_namespace" {
  type = string
  description = "The namespace where argocd has been deployed"
  default = "openshift-gitops"
}
variable "gitops_repo_host" {
  type = string
  description = "The host for the git repository."
  default = ""
}
variable "gitops_repo_type" {
  type = string
  description = "[Deprecated] The type of the hosted git repository."
  default = ""
}
variable "gitops_repo_org" {
  type = string
  description = "The org/group where the git repository exists/will be provisioned."
  default = ""
}
variable "gitops_repo_username" {
  type = string
  description = "The username of the user with access to the repository"
  default = ""
}
variable "gitops_repo_token" {
  type = string
  description = "The personal access token used to access the repository"
  default = ""
}
variable "gitops_repo_gitea_host" {
  type = string
  description = "The host for the git repository."
  default = ""
}
variable "gitops_repo_gitea_org" {
  type = string
  description = "The org/group where the git repository exists/will be provisioned."
  default = ""
}
variable "gitops_repo_gitea_username" {
  type = string
  description = "The username of the user with access to the repository"
  default = ""
}
variable "gitops_repo_gitea_token" {
  type = string
  description = "The personal access token used to access the repository"
  default = ""
}
variable "gitops_repo_repo" {
  type = string
  description = "The short name of the repository (i.e. the part after the org/group name)"
}
variable "gitops_repo_branch" {
  type = string
  description = "The name of the branch that will be used. If the repo already exists (provision=false) then it is assumed this branch already exists as well"
  default = "main"
}
variable "gitops_repo_public" {
  type = bool
  description = "Flag indicating that the repo should be public or private"
  default = false
}
variable "gitops_repo_gitops_namespace" {
  type = string
  description = "The namespace where ArgoCD is running in the cluster"
  default = "openshift-gitops"
}
variable "gitops_repo_server_name" {
  type = string
  description = "The name of the cluster that will be configured via gitops. This is used to separate the config by cluster"
  default = "default"
}
variable "gitops_repo_sealed_secrets_cert" {
  type = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default = ""
}
variable "gitops_repo_strict" {
  type = bool
  description = "Flag indicating that an error should be thrown if the repo already exists"
  default = false
}
variable "rwx_storage_class" {
  type = string
  description = "The storage class to use for Read-Write-Many volumes"
}
variable "rwo_storage_class" {
  type = string
  description = "The storage class to use for Read-Write-One volumes"
}
variable "file_storage_class" {
  type = string
  description = "The storage class to use for File storage volumes"
}
variable "block_storage_class" {
  type = string
  description = "The storage class to use for Block storage volumes"
}
variable "util-clis_bin_dir" {
  type = string
  description = "The directory where the clis should be downloaded. If not provided will default to ./bin"
  default = ""
}
variable "util-clis_clis" {
  type = string
  description = "The list of clis that should be made available in the bin directory. Supported values are yq, jq, igc, helm, argocd, rosa, gh, glab, and kubeseal. (If not provided the list will default to yq, jq, and igc)"
  default = "[\"yq\",\"jq\",\"igc\"]"
}
