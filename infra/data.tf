data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "workload_boundary_arn" {
  name = "/mypreflight/bootstrap/workload-boundary-arn"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/mypreflight/api/vpc-id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/mypreflight/api/public-subnet-ids"
}

data "aws_ssm_parameter" "cluster_arn" {
  name = "/mypreflight/api/cluster-arn"
}

data "aws_ssm_parameter" "alarms_topic_arn" {
  name = "/mypreflight/api/alarms-topic-arn"
}
