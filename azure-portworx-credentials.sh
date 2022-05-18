#!/bin/bash

set -e

## File sourced from https://github.com/cloud-native-toolkit/terraform-azure-portworx/blob/main/scripts/portworx-prereq.sh

Usage()
{
   echo "Retrieves the required credentials to install Portworx on Azure."
   echo
   echo "Usage: portworx-prereq.sh -t {cluster type} -g {resource group name} -n {cluster name} [-s {subscription id}]"
   echo "  options:"
   echo "  -t     Cluster type (ARO|IPI)"
   echo "  -g     Resource group name for OpenShift cluster"
   echo "  -n     Cluster name"
   echo "  -s     (optional) Azure subscription id"
   echo "  -h     Print this help"
   echo
}

SUBSCRIPTION_ID=""
RESOURCE_GROUP_NAME=""
CLUSTER_NAME=""
CLUSTER_TYPE=""

# Get the options
while getopts ":s:g:n:t:h:" option; do
   case $option in
      h) # display Help
         Usage
         exit 0;;
      t)
         CLUSTER_TYPE=$OPTARG;;
      s)
         SUBSCRIPTION_ID=$OPTARG;;
      g) # Enter a name
         RESOURCE_GROUP_NAME=$OPTARG;;
      n) # Enter a name
         CLUSTER_NAME=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         Usage
         exit 1;;
   esac
done

if ! command -v az 1> /dev/null 2> /dev/null; then
  echo "az cli not found" >&2
  exit 1
fi

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq cli not found" >&2
  exit 1
fi

if [[ -z "${RESOURCE_GROUP_NAME}" ]] || [[ -z "${CLUSTER_NAME}" ]] || [[ -z "${CLUSTER_TYPE}" ]]; then
  Usage
  exit 1
fi

if ! az account list-locations 1> /dev/null 2> /dev/null; then
  echo "Not logged into az cli" >&2
  exit 1
fi

if [[ -z "${SUBSCRIPTION_ID}" ]]; then
  az config set extension.use_dynamic_install=yes_without_prompt 1> /dev/null 2> /dev/null

  SUBSCRIPTIONS=$(az account subscription list 2> /dev/null)

  if [[ $(echo "${SUBSCRIPTIONS}" | jq '. | length') -eq 1 ]]; then
    SUBSCRIPTION_ID=$(echo "${SUBSCRIPTIONS}" | jq -r '.[] | .subscriptionId')
  elif [[ $(echo "${SUBSCRIPTIONS}" | jq '. | length') -gt 1 ]]; then
    SUBSCRIPTION_IDS=$(echo "${SUBSCRIPTIONS}" | jq -r '.[] | .subscriptionId' | tr '\n' ' ')

      PS3="Select the subscription id: "

      select id in ${SUBSCRIPTION_IDS}; do
        if [[ -n "${id}" ]]; then
          SUBSCRIPTION_ID="${id}"
          break
        fi
      done

      echo ""
  else
    echo "Unable to find subscription id" >&2
    exit 1
  fi
fi

CREDENTIALS=""

if [[ "${CLUSTER_TYPE}" =~ ARO|aro ]]; then
  echo "Preparing Portworx for ARO cluster"

  RAW_RESOURCE_GROUP_ID=$(az aro show --name "${CLUSTER_NAME}" -g "${RESOURCE_GROUP_NAME}" 2> /dev/null | jq -r '.clusterProfile.resourceGroupId')
  RESOURCE_GROUP_ID=$(echo "${RAW_RESOURCE_GROUP_ID}" | awk -F / '{print $NF}')
  APP_ID=$(az ad sp list --display-name "${RESOURCE_GROUP_ID}" 2> /dev/null | jq -r '.[].appId')
  CREDENTIALS=$(az ad app credential reset --id "${APP_ID}" --append 2> /dev/null)

else
  echo "Preparing Portworx for IPI cluster"

  ROLE_EXISTS=$(az role definition list -g "${RESOURCE_GROUP_NAME}" -n "portworx-${CLUSTER_NAME}" 2> /dev/null)
  if [[ ${#ROLE_EXISTS} -gt 2 ]] ; then
    echo "Role portworx-$CLUSTER_NAME already exists"
  else
    echo "creating role portworx-$CLUSTER_NAME"
    ROLE=$(az role definition create --role-definition '{
            "Name": "portworx-role-'${CLUSTER_NAME}'",
            "Description": "",
            "AssignableScopes": [
                "/subscriptions/'${SUBSCRIPTION_ID}'"
            ],
            "Permissions": [
                {
                    "Actions": [
                        "Microsoft.ContainerService/managedClusters/agentPools/read",
                        "Microsoft.Compute/disks/delete",
                        "Microsoft.Compute/disks/write",
                        "Microsoft.Compute/disks/read",
                        "Microsoft.Compute/virtualMachines/write",
                        "Microsoft.Compute/virtualMachines/read",
                        "Microsoft.Compute/virtualMachineScaleSets/virtualMachines/write",
                        "Microsoft.Compute/virtualMachineScaleSets/virtualMachines/read"
                    ],
                    "NotActions": [],
                    "DataActions": [],
                    "NotDataActions": []
                }
            ]
    }' 2> /dev/null)

    echo "creating service principal portworx-${CLUSTER_NAME}"
    CREDENTIALS=$(az ad sp create-for-rbac --role="portworx-role-${CLUSTER_NAME}" --scopes="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}" 2> /dev/null)
  fi
fi

if [[ -z "${CREDENTIALS}" ]]; then
  echo "CREDENTIALS are empty"
  exit 1
fi

echo "${CREDENTIALS}" | jq --arg SUBSCRIPTION_ID "${SUBSCRIPTION_ID}" \
  '{"azure_client_id": .appId, "azure_client_secret": .password, "azure_tenant_id": .tenant, "azure_subscription_id": $SUBSCRIPTION_ID}'
