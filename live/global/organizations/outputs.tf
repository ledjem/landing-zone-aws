output "root_id" {
  value = module.organization.root_id
}

output "security_ou_id" {
  value = module.security_ou.id
}

output "workloads_ou_id" {
  value = module.workloads_ou.id
}

output "security_account_id" {
  value = module.security_account.account_id
}

output "log_archive_account_id" {
  value = module.log_archive_account.account_id
}

output "workloads_account_id" {
  value = module.workloads_account.account_id
}
output "network_account_id" {
  value = module.network_account.account_id
}

output "infrastructure_ou_id" {
  value = module.infrastructure_ou.id
}