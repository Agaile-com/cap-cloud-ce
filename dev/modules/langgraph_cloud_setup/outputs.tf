output "langgraph_cloud_role_arn" {
  value = aws_iam_role.langgraph_cloud_role.arn
}

output "langgraph_service_sg_id" {
  value = aws_security_group.langgraph_cloud_service_sg.id
  description = "ID of the security group used by LangGraph Cloud services"
}
