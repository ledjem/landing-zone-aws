output "bucket_name" {
  value = module.cloudtrail_bucket.bucket_id
}

output "bucket_arn" {
  value = module.cloudtrail_bucket.bucket_arn
}
