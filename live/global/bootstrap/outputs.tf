output "state_bucket_name" {
  description = "Nom du bucket S3 à réutiliser dans la config backend des autres dossiers Terraform"
  value       = module.state_bucket.bucket_id
}

output "lock_table_name" {
  description = "Nom de la table DynamoDB à réutiliser dans la config backend des autres dossiers Terraform"
  value       = module.lock_table.table_name
}
