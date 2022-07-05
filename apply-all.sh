#!/usr/bin/env bash

echo "y" | terragrunt run-all apply --terragrunt-parallelism 1 || exit 1
