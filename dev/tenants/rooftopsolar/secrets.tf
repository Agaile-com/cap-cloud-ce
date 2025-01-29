# Create secrets for environment variables
resource "aws_secretsmanager_secret" "rooftopsolar_env" {
  name = "rooftopsolar/env/dev"
  tags = merge(local.common_tags, {
    Name = "rooftopsolar-env-secrets"
    Environment = "dev"  # Explicitly set to dev
  })
}

resource "aws_secretsmanager_secret_version" "rooftopsolar_env" {
  secret_id = aws_secretsmanager_secret.rooftopsolar_env.id
  secret_string = jsonencode({
    LANGCHAIN_API_KEY                 = "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"
    LANGGRAPH_API_URL                 = "https://cap-engine-dev-4208d61fda535e3ca2f1cc909135c696.us.langgraph.app"
    NEXT_PUBLIC_LANGGRAPH_ASSISTANT_ID = "6ada6340-487f-4e34-908a-bb97892b1aaf"
  })
} 