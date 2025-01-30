# Create secrets for environment variables
resource "aws_secretsmanager_secret" "agaile_env" {
  name = "agaile/env/dev"
  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "agaile_env" {
  secret_id = aws_secretsmanager_secret.agaile_env.id
  secret_string = jsonencode({
    LANGCHAIN_API_KEY              = "PLACEHOLDER"
    LANGGRAPH_API_URL             = "PLACEHOLDER"
    NEXT_PUBLIC_LANGGRAPH_ASSISTANT_ID = "PLACEHOLDER"
  })
} 