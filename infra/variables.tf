variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "desired_count" {
  description = "Running ADS-B tasks"
  type        = number
  default     = 1

  validation {
    condition     = contains([0, 1], var.desired_count)
    error_message = "Positions live in the task's memory, so ADS-B runs at most one task."
  }
}

variable "fargate_cpu" {
  type    = string
  default = "256"
}

variable "fargate_memory" {
  type    = string
  default = "512"
}

variable "cloudflared_image" {
  description = "cloudflare/cloudflared 2026.10.7, pinned by the digest of its multi-arch image index"
  type        = string
  default     = "cloudflare/cloudflared@sha256:4955524aeaa379e154023d5a027c250f7b35041a2e7e950cf13f144bc9b9c5ba"
}

variable "app_secrets_version" {
  type    = number
  default = 3
}

variable "admin_token" {
  type      = string
  sensitive = true
  ephemeral = true

  validation {
    condition     = length(var.admin_token) > 0
    error_message = "Set TF_VAR_admin_token."
  }
}

variable "client_token" {
  type      = string
  sensitive = true
  ephemeral = true

  validation {
    condition     = length(var.client_token) > 0
    error_message = "Set TF_VAR_client_token."
  }
}

variable "cloudflare_tunnel_token" {
  type      = string
  sensitive = true
  ephemeral = true

  validation {
    condition     = length(var.cloudflare_tunnel_token) > 0
    error_message = "Set TF_VAR_cloudflare_tunnel_token."
  }
}
