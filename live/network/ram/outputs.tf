data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "share_arn" {
  value = module.share_subnets_workloads.share_arn
}
