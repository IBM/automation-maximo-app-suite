#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

source "${SCRIPT_DIR}/validation-functions.sh"

if [[ -n "${BIN_DIR}" ]]; then
  export PATH="${BIN_DIR}:${PATH}"
fi

if [[ -z "${KUBECONFIG}" ]]; then
  echo "KUBECONFIG is not defined" >&2
  exit 1
fi

if [[ -z "${INSTANCE_ID}" ]]; then
  echo "INSTANCE_ID is not defined" >&2
  exit 1
fi

if ! command -v oc 1> /dev/null 2> /dev/null; then
  echo "oc cli not found" >&2
  exit 1
fi

if ! command -v kubectl 1> /dev/null 2> /dev/null; then
  echo "kubectl cli not found" >&2
  exit 1
fi

echo "*** Checking for Mongo resources ***"

MONGO_NS="mongo"
check_k8s_namespace "${MONGO_NS}"
check_k8s_resource "${MONGO_NS}" deployment mongodb-kubernetes-operator

echo "*** Checking for BAS resources ***"

BAS_NS="masbas"
check_k8s_namespace "${BAS_NS}"
check_k8s_resource "${BAS_NS}" deployment behavior-analytics-services-operator

echo "*** Checking for SLS resources ***"

SLS_NS="ibm-sls"
check_k8s_namespace "${SLS_NS}"
check_k8s_resource "${SLS_NS}" deployment sls-api-licensing

echo "*** Checking for MAS resources ***"

MAS_NS="mas-${INSTANCE_ID}-core"
check_k8s_namespace "${MAS_NS}"
check_k8s_resource "${MAS_NS}" deployment ibm-mas-operator
check_k8s_resource "${MAS_NS}" deployment mas8-coreidp-login
