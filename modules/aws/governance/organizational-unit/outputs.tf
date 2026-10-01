output "id" {
  description = "ID of the created OU"
  value       = aws_organizations_organizational_unit.this.id
}

output "arn" {
  description = "ARN of the created OU"
  value       = aws_organizations_organizational_unit.this.arn
}
