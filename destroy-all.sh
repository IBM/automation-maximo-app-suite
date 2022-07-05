#!/usr/bin/env bash

echo "y" | terragrunt run-all destroy --terragrunt-parallelism 1 || exit 1
