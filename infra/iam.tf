resource "aws_iam_role" "execution" {
  name                 = "${local.app_name}-execution"
  path                 = "/${local.name}/"
  permissions_boundary = data.aws_ssm_parameter.workload_boundary_arn.value

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "execution" {
  name = "execution"
  role = aws_iam_role.execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "WriteLogs"
        Effect   = "Allow"
        Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "${aws_cloudwatch_log_group.app.arn}:*"
      },
      {
        Sid    = "ReadSecrets"
        Effect = "Allow"
        Action = "ssm:GetParameters"
        Resource = concat(
          [for parameter in aws_ssm_parameter.secret : parameter.arn],
          [
            aws_ssm_parameter.cloudflare_tunnel_token.arn,
          ],
        )
      }
    ]
  })
}

resource "aws_iam_role" "task" {
  name                 = "${local.app_name}-task"
  path                 = "/${local.name}/"
  permissions_boundary = data.aws_ssm_parameter.workload_boundary_arn.value

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action    = "sts:AssumeRole"
        Condition = {
          StringEquals = { "aws:SourceAccount" = local.account_id }
          ArnLike      = { "aws:SourceArn" = "arn:aws:ecs:${var.aws_region}:${local.account_id}:*" }
        }
      }
    ]
  })
}
