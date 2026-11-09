resource "aws_security_group" "task" {
  name   = "${local.app_name}-task"
  vpc_id = data.aws_ssm_parameter.vpc_id.insecure_value

  egress {
    description = "HTTPS to GitHub Container Registry and the AWS APIs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "cloudflared tunnel to the Cloudflare edge over QUIC"
    from_port   = 7844
    to_port     = 7844
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "cloudflared tunnel to the Cloudflare edge over HTTP/2"
    from_port   = 7844
    to_port     = 7844
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.app_name}-task" }
}
