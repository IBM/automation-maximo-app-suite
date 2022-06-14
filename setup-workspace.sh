#!/bin/bash

# IBM GSI Ecosystem Lab
SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

Usage()
{
   echo "Creates a workspace folder and populates it with automation bundles you require."
   echo
   echo "Usage: setup-workspace.sh"
   echo "  options:"
   echo "  -p     Cloud provider (aws, azure, ibm)"
   echo "  -s     Storage (portworx or odf)"
   echo "  -c     (optional) Cluster ingress - the subdomain for ingress urls into the cluster"
   echo "  -n     (optional) Prefix that should be used for all variables"
   echo "  -x     (optional) Portworx spec file - the name of the file containing the Portworx configuration spec yaml"
   echo "  -h     Print this help"
   echo
}

CLUSTER_INGRESS=""
CLOUD_PROVIDER=""
STORAGE=""
PREFIX_NAME=""
PORTWORX_SPEC_FILE=""

if [[ "$1" == "-h" ]]; then
  Usage
  exit 1
fi

# Get the options
while getopts ":p:s:n:c:x:h:" option; do
   case $option in
      h) # display Help
         Usage
         exit 1;;
      p)
         CLOUD_PROVIDER=$OPTARG;;
      s) # Enter a name
         STORAGE=$OPTARG;;
      c) # Enter a name
         CLUSTER_INGRESS=$OPTARG;;
      n) # Enter a name
         PREFIX_NAME=$OPTARG;;
      x) # Enter a name
         PORTWORX_SPEC_FILE=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         Usage
         exit 1;;
   esac
done

RED='\033[0;31m'
YELLOW='\033[0;33m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

if [[ -z "${CLOUD_PROVIDER}" ]]; then
  PS3="Select the cloud provider: "

  select provider in aws azure ibm; do
    if [[ -n "${provider}" ]]; then
      CLOUD_PROVIDER="${provider}"
      break
    fi
  done

  echo ""
fi

if [[ ! "${CLOUD_PROVIDER}" =~ ^aws|azure|ibm ]]; then
  echo "Invalid value for cloud provider: ${CLOUD_PROVIDER}" >&2
  exit 1
fi

if [[ -z "${STORAGE}" ]] && [[ "${CLOUD_PROVIDER}" == "ibm" ]]; then
  PS3="Select the storage provider: "

  select storage in portworx odf; do
    if [[ -n "${storage}" ]]; then
      STORAGE="${storage}"
      break
    fi
  done

  echo ""
elif [[ -z "${STORAGE}" ]]; then
  STORAGE="portworx"
fi

if [[ ! "${STORAGE}" =~ ^odf|portworx ]]; then
  echo "Invalid value for storage provider: ${STORAGE}" >&2
  exit 1
fi

if [[ -z "${PREFIX_NAME}" ]]; then
  echo -n "Provide a prefix name: "
  read -r PREFIX_NAME
  echo ""
fi

if [[ "${CLOUD_PROVIDER}" == "aws" ]]; then
  RWO_STORAGE="gp2"
elif [[ "${CLOUD_PROVIDER}" == "azure" ]]; then
  RWO_STORAGE="managed-premium"
elif [[ "${CLOUD_PROVIDER}" == "ibm" ]] || [[ "${CLOUD_PROVIDER}" == "ibmcloud" ]]; then
  RWO_STORAGE="ibmc-vpc-block-10iops-tier"
else
  RWO_STORAGE="<your block storage on aws: gp2, on azure: managed-premium, on ibm: ibmc-vpc-block-10iops-tier>"
fi

if [[ "${STORAGE}" == "portworx" ]]; then
  RWX_STORAGE="portworx-rwx-gp3-sc"
elif [[ "${STORAGE}" == "odf" ]]; then
  RWX_STORAGE="ocs-storagecluster-cephfs"
else
  RWX_STORAGE="<read-write-many storage class (e.g. portworx: portworx-rwx-gp3-sc or odf: ocs-storagecluster-cephfs)>"
fi

if [[ "${CLOUD_PROVIDER}" =~ aws|azure ]] && [[ -z "${PORTWORX_SPEC_FILE}" ]]; then
  if command -v oc 1> /dev/null 2> /dev/null; then
    echo "Looking for existing portworx storage class: ${RWX_STORAGE}"

    if ! oc login "${TF_VAR_server_url}" --token="${TF_VAR_cluster_login_token}" --insecure-skip-tls-verify=true 1> /dev/null; then
      exit 1
    fi

    if oc get storageclass "${RWX_STORAGE}" 1> /dev/null 2> /dev/null; then
      echo "  Found existing portworx installation. Skipping storage layer..."
      echo ""
      PORTWORX_SPEC_FILE="installed"
    fi
  fi

  if [[ -z "${PORTWORX_SPEC_FILE}" ]]; then
    DEFAULT_FILE=$(find . -name "portworx*.yaml" -maxdepth 1 -exec basename {} \; | head -1)

    while [[ -z "${PORTWORX_SPEC_FILE}" ]]; do
      echo -n "Provide the Portworx config spec file name: [${DEFAULT_FILE}] "
      read -r PORTWORX_SPEC_FILE

      if [[ -z "${PORTWORX_SPEC_FILE}" ]] && [[ -n "${DEFAULT_FILE}" ]]; then
        PORTWORX_SPEC_FILE="${DEFAULT_FILE}"
      fi
    done

    echo ""
  fi
elif [[ "${CLOUD_PROVIDER}" == "ibm" ]]; then
  PORTWORX_SPEC_FILE=""
fi

if [[ -n "${PORTWORX_SPEC_FILE}" ]] && [[ "${PORTWORX_SPEC_FILE}" != "installed" ]] && [[ ! -f "${PORTWORX_SPEC_FILE}" ]]; then
  echo "Portworx spec file not found: ${PORTWORX_SPEC_FILE}" >&2
  exit 1
fi

if [[ -z "${CLUSTER_INGRESS}" ]]; then
  if command -v oc 1> /dev/null 2> /dev/null && [[ -n "$TF_VAR_server_url" ]] && [[ -n "$TF_VAR_server_url" ]]; then
    echo "Looking up cluster ingress"

    if oc login "${TF_VAR_server_url}" --token="${TF_VAR_cluster_login_token}" --insecure-skip-tls-verify=true 1> /dev/null; then
      CLUSTER_INGRESS=$(oc get ingresses.config/cluster -o jsonpath={.spec.domain})
    else
      exit 1
    fi
  fi

  if [[ -z "${CLUSTER_INGRESS}" ]]; then
    echo -e "${YELLOW}Unable to lookup cluster ingress.${NC} The value can be retrieved by running:"
    echo -e "  ${WHITE}oc get ingresses.config/cluster -o jsonpath={.spec.domain}${NC}"
    echo -n "Cluster ingress: "
    read -r CLUSTER_INGRESS
  else
    echo "  Found cluster ingress: ${CLUSTER_INGRESS}"
    echo ""
  fi
fi

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)
WORKSPACES_DIR="${SCRIPT_DIR}/../workspaces"
WORKSPACE_DIR="${WORKSPACES_DIR}/current"

if [[ -n "${PREFIX_NAME}" ]]; then
  PREFIX_NAME="${PREFIX_NAME}-"
fi

if [[ -d "${WORKSPACE_DIR}" ]]; then
  DATE=$(date "+%Y%m%d%H%M")
  mv "${WORKSPACE_DIR}" "${WORKSPACES_DIR}/workspace-${DATE}"

  cp "${SCRIPT_DIR}/terraform.tfvars" "${WORKSPACES_DIR}/workspace-${DATE}/terraform.tfvars"
fi

echo "Setting up workspace in '${WORKSPACE_DIR}'"
echo "*****"

mkdir -p "${WORKSPACE_DIR}"

PORTWORX_SPEC_FILE_BASENAME=$(basename "${PORTWORX_SPEC_FILE}")

if [[ -n "${PORTWORX_SPEC_FILE}" ]] && [[ "${PORTWORX_SPEC_FILE}" != "installed" ]]; then
  cp "${PORTWORX_SPEC_FILE}" "${WORKSPACE_DIR}/${PORTWORX_SPEC_FILE_BASENAME}"
fi

cd "${WORKSPACE_DIR}"

cat "${SCRIPT_DIR}/terraform.tfvars.template" | \
  sed "s/PREFIX/${PREFIX_NAME}/g" | \
  sed "s/CLUSTER_INGRESS/${CLUSTER_INGRESS}/g" | \
  sed "s/RWX_STORAGE/${RWX_STORAGE}/g" | \
  sed "s/RWO_STORAGE/${RWO_STORAGE}/g" | \
  sed "s/PORTWORX_SPEC_FILE/${PORTWORX_SPEC_FILE_BASENAME}/g" \
  > "${SCRIPT_DIR}/terraform.tfvars"

ln -s "${SCRIPT_DIR}/terraform.tfvars" ./terraform.tfvars

cp "${SCRIPT_DIR}/apply-all.sh" "${WORKSPACE_DIR}/apply-all.sh"
cp "${SCRIPT_DIR}/destroy-all.sh" "${WORKSPACE_DIR}/destroy-all.sh"

WORKSPACE_DIR=$(cd "${WORKSPACE_DIR}"; pwd -P)

if [[ "${PORTWORX_SPEC_FILE}" == "installed" ]]; then
  ALL_ARCH="200|400"
else
  ALL_ARCH="200|210|400"
fi

find ${SCRIPT_DIR}/. -type d -maxdepth 1 | grep -vE "[.][.]/[.].*" | grep -v workspace | sort | \
  while read dir;
do

  name=$(echo "$dir" | sed -E "s/.*\///")

  if [[ ! -d "${SCRIPT_DIR}/${name}/terraform" ]]; then
    continue
  fi

  if [[ ! "${name}" =~ ${ALL_ARCH} ]]; then
    continue
  fi

  if [[ -n "${STORAGE}" ]] && [[ -n "${CLOUD_PROVIDER}" ]]; then
    BOM_STORAGE=$(grep -E "^ +storage" "${SCRIPT_DIR}/${name}/bom.yaml" | sed -E "s~[^:]+: [\"']?(.*)[\"']?~\1~g")
    BOM_PROVIDER=$(grep -E "^ +platform" "${SCRIPT_DIR}/${name}/bom.yaml" | sed -E "s~[^:]+: [\"']?(.*)[\"']?~\1~g")

    if [[ -n "${BOM_PROVIDER}" ]] && [[ "${BOM_PROVIDER}" != "${CLOUD_PROVIDER}" ]]; then
      echo "  Skipping ${name} because it doesn't match ${CLOUD_PROVIDER}"
      continue
    fi

    if [[ -n "${BOM_STORAGE}" ]] && [[ "${BOM_STORAGE}" != "${STORAGE}" ]]; then
      echo "  Skipping ${name} because it doesn't match ${STORAGE}"
      continue
    fi
  fi

  echo "Setting up current/${name} from ${name}"

  mkdir -p ${name}
  cd "${name}"

  cp -R "${SCRIPT_DIR}/${name}/terraform/"* .
  ln -s "${WORKSPACE_DIR}"/terraform.tfvars ./terraform.tfvars
  if [[ -n "${PORTWORX_SPEC_FILE_BASENAME}" ]]; then
    ln -s "${WORKSPACE_DIR}/${PORTWORX_SPEC_FILE_BASENAME}" "./${PORTWORX_SPEC_FILE_BASENAME}"
  fi

  cd - > /dev/null
done

echo "Move to ${WORKSPACE_DIR} this is where your automation is configured"
