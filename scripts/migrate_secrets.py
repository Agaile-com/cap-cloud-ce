import os
from azure.keyvault.secrets import SecretClient
from azure.identity import DefaultAzureCredential

def migrate_secrets():
    # Initialize the Vault client with Agaile tenant
    credential = DefaultAzureCredential(tenant_id="agaile-tenant-id")
    vault_url = os.environ["AGAILE_VAULT_URL"]
    client = SecretClient(vault_url=vault_url, credential=credential)
    
    # Read secrets from configuration
    secrets = read_current_secrets()
    
    # Store in Agaile vault
    for key, value in secrets.items():
        client.set_secret(key, value) 