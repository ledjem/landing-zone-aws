provider "aws" {
  region  = var.aws_region
  profile = "log-archive"
}

module "config_bucket" {
  source = "../../../modules/aws/storage/s3"

  bucket_name         = var.bucket_name
  versioning_enabled  = true
  encryption_enabled  = true
  block_public_access = true

  tags = {
    Project = "landing-zone"
    Purpose = "config-logs"
  }
}

module "config_bucket_policy" {
  source = "../../../modules/aws/storage/s3-bucket-policy"

  bucket_id = module.config_bucket.bucket_id

  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSConfigBucketPermissionsCheck"
        Effect    = "Allow"
        Principal = { Service = "config.amazonaws.com" }
        Action    = ["s3:GetBucketAcl", "s3:ListBucket"]
        Resource  = module.config_bucket.bucket_arn
        Condition = {
          StringEquals = { "aws:SourceOrgID" = var.organization_id }
        }
      },
      {
        Sid       = "AWSConfigBucketDelivery"
        Effect    = "Allow"
        Principal = { Service = "config.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${module.config_bucket.bucket_arn}/AWSLogs/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"    = "bucket-owner-full-control"
            "aws:SourceOrgID" = var.organization_id
          }
        }
      }
    ]
  })

  depends_on = [module.config_bucket]
}