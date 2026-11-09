locals {
  name           = "adsb-receiver-api"
  package        = jsondecode(file("${path.module}/../package.json"))
  app_name       = local.package.name
  app_image      = "ghcr.io/${local.package.author}/${local.package.name}:${local.package.version}"
  app_port       = 3000
  parameter_path = "/mypreflight/${local.name}"
  account_id     = data.aws_caller_identity.current.account_id
  cluster_arn    = data.aws_ssm_parameter.cluster_arn.insecure_value
  cluster_name   = element(split("/", local.cluster_arn), 1)

  secret_values = {
    ADMIN_TOKEN  = var.admin_token
    CLIENT_TOKEN = var.client_token
  }

  secret_names = toset(["ADMIN_TOKEN", "CLIENT_TOKEN"])
}
