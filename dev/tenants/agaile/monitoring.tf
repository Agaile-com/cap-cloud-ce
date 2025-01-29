# Remove this resource since it's already created in the ECS module
# resource "aws_cloudwatch_log_group" "ecs_agaile" {
#   name              = "/ecs/agaile-service"
#   retention_in_days = 1
# 
#   tags = merge(local.common_tags, {
#     Name    = "${var.tenant_name}-ecs-logs"
#     Purpose = "monitoring"
#     Service = var.tenant_name
#   })
# } 