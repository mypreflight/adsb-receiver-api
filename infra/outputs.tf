output "service_name" {
  value = aws_ecs_service.app.name
}

output "app_image" {
  value = local.app_image
}
