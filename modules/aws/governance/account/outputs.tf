output "account_id" {
  description = "ID of the created AWS account"
  value       = aws_organizations_account.this.id
}

output "account_arn" {
  description = "ARN of the created AWS account"
  value       = aws_organizations_account.this.arn
}