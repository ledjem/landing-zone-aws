variable "bucket_id" {
  type        = string
  description = "ID (name) of the S3 bucket to attach the policy to"
}

variable "policy_json" {
  type        = string
  description = "JSON content of the bucket policy"
}
