#  Maximo Application Suite - MAS Manage Deployment


## TODO - Need to Insert Here Manage BOM specifics




Deploys MAS Manage applications as part of Maximo Application Suite via gitops.  To run, download the BOM (Bill of Materials) from the module catalog and build the terraform from there.  Specify the MAS-Core instance id - in the `instanceid` variable.  This will create a namespace of the name `mas-(instanceid)-manage`.

Note if your cluster is not setup for gitops, download the gitops bootstrap BOM from the module catalog first to setup the gitops tooling.

## Supported Manage Industry Add-on solutions
This module currently supports installing the following add-ons with MAS Manage:
- Health
- Civil Infrastructure

Override the `addons` variable such that it looks like the following to deploy health with Manage: 

`addons = ["health"]`

To deploy Civil Infrastructure use:

`addons = ["civil"]`

The other industry solutions follow the same format and are comma separated if more than one is needed.  Note be sure to check MAS requirements as not all industry solutions can be deployed together.

## Database re-use
(skip if this is a new install and not re-using a database)

You can reuse an existing Manage database by setting:   `reuse_db = true`  when calling the module.  If you are re-using the database then you must supply the `crypto` and `cryptox` keys from the previous install of Manage that encrypted the database or this new Manage install will fail when trying to access the database.  NOTE: The cypto keys are base64 encoded.  If you are copying the two crypto keys from a previous install directly from the cluster and for example download the `demo-manage-encryptionsecret.yaml` within the `manage` namespace, these will already have been base64 encoded and require you to decode them before setting them in the below two variables.  If not done, they will end up base6 encoded twice and the installation will not succeed.

You can decode a key by running the following from a terminal prompt:

`echo -n (your base64 key) | base64 --decode`

```
  crypto_key = var.database_crypto_key
  cryptox_key = var.database_cryptox_key
```

## DB2Warehouse Setup
If you are using DB2 Warehouse as your supported database, before you can install MAS Manage, DB2 Warehouse needs to be setup and requires DB2 administration tasks to be run.  It is recommended a DB2 specialist run the script: `db2_manage_upd.sh` found in the `scripts` directory of this repository.


## Supported platforms

- OCP 4.8+


## Example usage

```hcl-terraform
module "mas_manage" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-mas-manage"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  kubeseal_cert = module.gitops.sealed_secrets_cert
  entitlement_key = module.catalog.entitlement_key
  instanceid = "mas8"
  appid = "manage"
  workspace_id = "demo"
  demodata = true
  addons = ["health"]

}
```
