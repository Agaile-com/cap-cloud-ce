#!/bin/bash
echo "Deploying CAP Cloud Community Version..."
terraform init ./community/terraform/
terraform apply ./community/terraform/
