#!/usr/bin/env bash

CI="$1"

if [[ -n "${CI}" ]]; then
  NON_INTERACTIVE="--terragrunt-non-interactive"
fi

terragrunt run-all apply --terragrunt-parallelism 1 ${NON_INTERACTIVE} --terragrunt-exclude-dir="${PWD}/.mocks/"*
