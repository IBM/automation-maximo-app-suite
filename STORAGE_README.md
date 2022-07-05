# IBM Cloud - OCP Cluster Storage

Read-write-many (RWX) storage is required for many types of software deployments, including IBM Cloud Pak for Data, IBM Maximo Application Suite, and more.

The automation for RedHat OpenShift on IBM Cloud (ROKS) supports two storage mechanisms:

- Portworx Storage
- OpenShift Data Foundation (ODF)

Either one of these solutions can satisfy the RWX storage access modes for StorageClass instances created within your OpenShift cluster.

# Deploying 

To enable RWX StorageClass access modes within your cluster, you need to deploy at least one of the two storage modules.  Both can be installed side by side, but it is recommended to only install one storage mechanism.  

## Portworx Storage:

Portworx-Enterprise is a widely-used and reliable cloud-native storage solution for production workloads and provides high-availability, data protection and security for containerized applications.

To deploy Portworx storage:

- `cd` into the `210-ibm-portworx-storage` folder.
- Modify the `terraform/210-ibm-portworx-storage.auto.tfvars` file to point at your cluster and include a valid API Key:

  ```
  ## region: The IBM Cloud region where the cluster will be/has been installed.
  region="us-east"
  
  ## ibmcloud_api_key: The IBM Cloud api token
  ibmcloud_api_key="XXXXXXXXXXXXXXXXXXXXXXXX"
    
  ## cluster_name: The cluster where Portworx storage will be deployed.
  cluster_name="mycluster"
    
  ## resource_group_name: The name of the resource group
  resource_group_name="myresourcegroup"
  ```

- Execute the `apply.sh` script


## ODF Storage:

Red Hat® OpenShift® Data Foundation—previously Red Hat OpenShift Container Storage—is software-defined storage for containers. Engineered as the data and storage services platform for Red Hat OpenShift, Red Hat OpenShift Data Foundation helps teams develop and deploy applications quickly and efficiently across clouds.

To deploy ODF storage:

- `cd` into the `210-ibm-odf-storage` folder.
- Modify the `terraform/210-ibm-odf-storage.auto.tfvars` file to point at your cluster and include a valid API Key:

  ```
  ## region: The IBM Cloud region where the cluster will be/has been installed.
  region="us-east"
  
  ## ibmcloud_api_key: The IBM Cloud api token
  ibmcloud_api_key="XXXXXXXXXXXXXXXXXXXXXXXX"
    
  ## cluster_name: The cluster where Portworx storage will be deployed.
  cluster_name="mycluster"
    
  ## resource_group_name: The name of the resource group
  resource_group_name="myresourcegroup"
  ```

- Execute the `apply.sh` script
