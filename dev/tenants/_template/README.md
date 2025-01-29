# New Tenant Setup Guide

## Steps to Create a New Tenant

1. Create a new directory for your tenant:
   ```bash
   cp -r _template/ new-tenant-name/
   cd new-tenant-name/
   ```

2. Rename and update configuration files:
   ```bash
   mv terraform.tfvars.template terraform.tfvars
   ```

3. Update the following in terraform.tfvars:
   - tenant_name
   - certificate_arn (if different)
   - container_environment variables
   - Any other tenant-specific values

4. Initialize and apply Terraform:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Required Values

- TENANT_NAME: The name of your tenant (will be used in resource names)
- ACCOUNT_ID: Your AWS account ID
- CERTIFICATE_ID: The SSL certificate ID for the ALB
- LANGCHAIN_API_KEY: The API key for Langchain
- LANGGRAPH_API_URL: The URL for your Langgraph instance
- NEXT_PUBLIC_LANGGRAPH_ASSISTANT_ID: The Assistant ID for your tenant

## Notes

- All resources will be created with standard tags and naming conventions
- The ALB will be created with HTTPS listener and HTTP redirect
- ECS tasks will run on ARM64 architecture for cost optimization 