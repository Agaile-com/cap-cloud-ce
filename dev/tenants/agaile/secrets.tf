# Create secrets for environment variables
resource "aws_secretsmanager_secret" "agaile_env" {
  name = "agaile/env/dev"
  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "agaile_env" {
  secret_id = aws_secretsmanager_secret.agaile_env.id
  secret_string = jsonencode({
    LANGCHAIN_API_KEY              = "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"
    LANGGRAPH_API_URL             = "https://cap-engine-dev-4208d61fda535e3ca2f1cc909135c696.us.langgraph.app"
    NEXT_PUBLIC_LANGGRAPH_ASSISTANT_ID = "d8a7f747-77ce-4b59-b3ff-754b46155d79"
  })
} 