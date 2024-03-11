#!/bin/bash

# Removes resources of a type from the terraform state

set -eu

resource_type=$1
resource_names=($(terraform state list | grep $resource_type))

for resource_name in "${resource_names[@]}"; do
  terraform state rm "$resource_name"
done
