output "id" {
  description = "ID of the Organization"
  value       = aws_organizations_organization.this.id
}

output "arn" {
  description = "ARN of the Organization"
  value       = aws_organizations_organization.this.arn
}

output "root_id" {
  description = "ID of the root OU — used as parent_id for top-level OUs"
  value       = aws_organizations_organization.this.roots[0].id
}