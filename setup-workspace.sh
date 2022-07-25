#!/bin/bash

# IBM GSI Ecosystem Lab
SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

Usage()
{
   echo "Creates a workspace folder and populates it with automation bundles you require."
   echo
   echo "Usage: setup-workspace.sh"
   echo "  options:"
   echo "  -p      Cloud provider (aws, azure, ibm)"
   echo "  -s      Storage (portworx or odf or <RWX storage class>)"
   echo "  -n      (optional) Prefix that should be used for all variables"
   echo "  -x      (optional) Portworx spec file - the name of the file containing the Portworx configuration spec yaml"
   echo "  -g      (optional) the git host that will be used for the gitops repo. If left blank gitea will be used by default. (Github, Github Enterprise, Gitlab, Bitbucket, Azure DevOps, and Gitea servers are supported)"
   echo "  -a      Adds the configuration to the existing workspace"
   echo "  -h      Print this help"
   echo
}

CLOUD_PROVIDER=""
STORAGE=""
PREFIX_NAME=""
PORTWORX_SPEC_FILE=""
APPEND=""
GIT_HOST=""

if [[ "$1" == "-h" ]]; then
  Usage
  exit 1
fi

# Get the options
while getopts ":p:s:n:x:a:g:h:" option; do
   case $option in
      h) # display Help
         Usage
         exit 0;;
      a)
         APPEND="true";;
      p)
         CLOUD_PROVIDER=$OPTARG;;
      s) # Enter a name
         STORAGE=$OPTARG;;
      n) # Enter a name
         PREFIX_NAME=$OPTARG;;
      x) # Enter a name
         PORTWORX_SPEC_FILE=$OPTARG;;
      g) # Enter a name
         GIT_HOST=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         Usage
         exit 1;;
   esac
done

ARG_ARRAY=( "$@" )


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
  PS3="Select the storage provider: "

  select storage in portworx other; do
    if [[ -n "${storage}" ]]; then
      STORAGE="${storage}"
      break
    fi
  done

  if [[ "${STORAGE}" == "other" ]]; then
    echo ""
    echo -n "Provide the read-write-many (RWX) storage class: "
    read -r STORAGE
  fi

  echo ""
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
elif [[ -n "${STORAGE}" ]]; then
  RWX_STORAGE="${STORAGE}"
else
  RWX_STORAGE="<read-write-many storage class (e.g. portworx: portworx-rwx-gp3-sc or odf: ocs-storagecluster-cephfs)>"
fi

if [[ "${CLOUD_PROVIDER}" =~ aws|azure ]] && [[ "${STORAGE}" == "portworx" ]] && [[ -z "${PORTWORX_SPEC_FILE}" ]]; then
  if command -v oc 1> /dev/null 2> /dev/null; then
    echo "Looking for existing portworx storage class: ${RWX_STORAGE}"

    if command -v oc 1> /dev/null 2> /dev/null && ! oc login "${TF_VAR_server_url}" --token="${TF_VAR_cluster_login_token}" --insecure-skip-tls-verify=true 1> /dev/null 2> /dev/null; then
      echo -e "${YELLOW}WARNING: ${WHITE}Unable to log into cluster.${NC} Check the cluster credentials in ${WHITE}credentials.properties${NC}"
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

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
WORKSPACES_DIR="${SCRIPT_DIR}/../workspaces"
WORKSPACE_DIR="${WORKSPACES_DIR}/current"

if [[ -n "${PREFIX_NAME}" ]]; then
  PREFIX_NAME="${PREFIX_NAME}-"
fi

ARG_ARRAY=( "$@" )

if [[ " ${ARG_ARRAY[*]} " =~ " -a " ]]; then
  APPEND="true"
fi

echo "Setting up workspace in '${WORKSPACE_DIR}'"
echo "*****"

if [[ -d "${WORKSPACE_DIR}" ]] && [[ "${APPEND}" != "true" ]]; then
  DATE=$(date "+%Y%m%d%H%M")
  echo "  Saving current workspaces directory to workspace-${DATE}"
  mv "${WORKSPACE_DIR}" "${WORKSPACES_DIR}/workspace-${DATE}"

  cp "${SCRIPT_DIR}/maximo.tfvars" "${WORKSPACES_DIR}/workspace-${DATE}/maximo.tfvars"
fi

mkdir -p "${WORKSPACE_DIR}"

PORTWORX_SPEC_FILE_BASENAME=$(basename "${PORTWORX_SPEC_FILE}")

if [[ -n "${PORTWORX_SPEC_FILE}" ]] && [[ "${PORTWORX_SPEC_FILE}" != "installed" ]]; then
  cp "${PORTWORX_SPEC_FILE}" "${WORKSPACE_DIR}/${PORTWORX_SPEC_FILE_BASENAME}"
fi

if [[ -z "${GIT_HOST}" ]]; then
  GITHOST_COMMENT="#"
fi

cd "${WORKSPACE_DIR}"

cat "${SCRIPT_DIR}/terraform.tfvars.template-maximo" | \
  sed "s/PREFIX/${PREFIX_NAME}/g" | \
  sed "s/RWX_STORAGE/${RWX_STORAGE}/g" | \
  sed "s/RWO_STORAGE/${RWO_STORAGE}/g" | \
  sed "s/PORTWORX_SPEC_FILE/${PORTWORX_SPEC_FILE_BASENAME}/g" \
  > "${WORKSPACE_DIR}/maximo.tfvars"

if [[ ! -f "${WORKSPACE_DIR}/gitops.tfvars" ]]; then
  cat "${SCRIPT_DIR}/terraform.tfvars.template-gitops" | \
    sed -E "s/#(.*=\"GIT_HOST\")/${GITHOST_COMMENT}\1/g" | \
    sed "s/PREFIX/${PREFIX_NAME}/g"  | \
    sed "s/GIT_HOST/${GIT_HOST}/g" \
    > "${WORKSPACE_DIR}/gitops.tfvars"
fi

cp "${SCRIPT_DIR}/apply-all.sh" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/destroy-all.sh" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/plan-all.sh" "${WORKSPACE_DIR}"
cp -R "${SCRIPT_DIR}/.mocks" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/layers.yaml" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/terragrunt.hcl" "${WORKSPACE_DIR}"

WORKSPACE_DIR=$(cd "${WORKSPACE_DIR}"; pwd -P)

if { [[ -z "${PORTWORX_SPEC_FILE}" ]] && [[ "${CLOUD_PROVIDER}" != "ibm" ]]; } || [[ "${PORTWORX_SPEC_FILE}" == "installed" ]]; then
  ALL_ARCH="200|400"
else
  ALL_ARCH="200|210|400"
fi

find ${SCRIPT_DIR}/. -maxdepth 1 -type d | grep -vE "[.][.]/[.].*" | grep -v workspace | sort | \
  while read dir;
do
  name=$(echo "$dir" | sed -E "s/.*\///")

  if [[ ! -f "${SCRIPT_DIR}/${name}/main.tf" ]]; then
    continue
  fi

  if [[ ! "${name}" =~ ${ALL_ARCH} ]]; then
    echo "  Layer doesn't match architecture. Skipping layer: ${name}"
    continue
  fi

  if [[ -n "${STORAGE}" ]] && [[ -n "${CLOUD_PROVIDER}" ]]; then
    BOM_STORAGE=$(grep -E "^ +storage" "${SCRIPT_DIR}/${name}/bom.yaml" | sed -E "s~[^:]+: [\"']?(.*)[\"']?~\1~g")
    BOM_PROVIDER=$(grep -E "^ +platform" "${SCRIPT_DIR}/${name}/bom.yaml" | sed -E "s~[^:]+: [\"']?(.*)[\"']?~\1~g")

    if [[ -n "${BOM_PROVIDER}" ]] && [[ "${BOM_PROVIDER}" != "${CLOUD_PROVIDER}" ]]; then
      echo "  Skipping ${name} because it doesn't match ${CLOUD_PROVIDER} cloud provider"
      continue
    fi

    if [[ -n "${BOM_STORAGE}" ]] && [[ "${BOM_STORAGE}" != "${STORAGE}" ]]; then
      echo "  Skipping ${name} because it doesn't match ${STORAGE} storage provider"
      continue
    fi
  fi

  echo "Setting up current/${name} from ${name}"

  mkdir -p ${name}
  cd "${name}"

  cp -R "${SCRIPT_DIR}/${name}/"* .
  if [[ -n "${PORTWORX_SPEC_FILE_BASENAME}" ]]; then
    ln -s "${WORKSPACE_DIR}/${PORTWORX_SPEC_FILE_BASENAME}" "./${PORTWORX_SPEC_FILE_BASENAME}"
  fi

  cd - > /dev/null
done

echo "Move to ${WORKSPACE_DIR} this is where your automation is configured"
