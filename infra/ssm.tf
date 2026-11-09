resource "aws_ssm_parameter" "secret" {
  for_each = local.secret_names

  name             = "${local.parameter_path}/${lower(replace(each.key, "_", "-"))}"
  type             = "SecureString"
  value_wo         = local.secret_values[each.key]
  value_wo_version = var.app_secrets_version
}

resource "aws_ssm_parameter" "cloudflare_tunnel_token" {
  name             = "${local.parameter_path}/cloudflare-tunnel-token"
  type             = "SecureString"
  value_wo         = var.cloudflare_tunnel_token
  value_wo_version = var.app_secrets_version
}
