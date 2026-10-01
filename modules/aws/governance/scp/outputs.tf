output "policy_id" {
  description = "ID of the created SCP"
  value       = aws_organizations_policy.this.id
}