# Create secrets for environment variables
resource "aws_secretsmanager_secret" "zohlar_env" {
  name = "zohlar/env/dev"
  tags = merge(local.common_tags, {
    Name = "zohlar-env-secrets"
    Environment = "dev"  # Explicitly set to dev
  })
}

resource "aws_secretsmanager_secret_version" "zohlar_env" {
  secret_id = aws_secretsmanager_secret.zohlar_env.id
  secret_string = jsonencode({
    LANGCHAIN_API_KEY              = "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"
    LANGGRAPH_API_URL                  = "https://cap-engine-dev-zohlar.us.langgraph.app"
    NEXT_PUBLIC_LANGGRAPH_ASSISTANT_ID = "fefda989-9c0e-4ddd-94d8-d1b5540b17bc"
  })
} 