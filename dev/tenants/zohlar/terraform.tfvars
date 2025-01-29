aws_region  = "eu-central-1"
environment = "prod"
tenant_name = "zohlar"

# ALB Configuration
certificate_arn   = "arn:aws:acm:eu-central-1:585008045756:certificate/4f61e572-4942-4f60-8415-3e69ae1d0057"
health_check_path = "/api/health"

# ECS Configuration
container_image = "585008045756.dkr.ecr.eu-central-1.amazonaws.com/zohlar-cap-engine"
container_port  = 3000
task_cpu        = 256
task_memory     = 512
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

# CloudFront Configuration
cloudfront_certificate_arn = "arn:aws:cloudfront::585008045756:distribution/E1DS5AM1Q3DT08" 