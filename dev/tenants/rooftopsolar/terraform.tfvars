aws_region  = "eu-central-1"
environment = "dev"
tenant_name = "rooftopsolar"

# Container Configuration
container_image = "585008045756.dkr.ecr.eu-central-1.amazonaws.com/rooftopsolar-cap-engine:latest"
container_port  = 3000
health_check_path = "/"

# ECS Configuration
task_cpu = 256
task_memory = 512
service_desired_count = 1

container_environment = [
  {
    name  = "ENVIRONMENT"
    value = "prod"
  },
  {
    name  = "LANGCHAIN_API_KEY"
    value = "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"
  },
  {
    name  = "LANGGRAPH_API_URL"
    value = "https://cap-engine-prod-3a92666954b25377b9618182229aa012.us.langgraph.app"
  },
  {
    name  = "NEXT_PUBLIC_LANGGRAPH_ASSISTANT_ID"
    value = "9aa00dfd-da8d-4655-9021-fb3de027a141"
  }
] 