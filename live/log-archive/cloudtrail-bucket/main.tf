terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "jeremie-lz-tfstate-base"
    key            = "log-archive/cloudtrail-bucket/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-landing-zone"
    encrypt        = true
  }
}

# Les ressources sont créées dans le compte Log Archive
provider "aws" {
  region  = var.aws_region
  profile = "log-archive"
}

locals {
  # ARN du futur trail (créé plus tard depuis Management)
  trail_arn = "arn:aws:cloudtrail:${var.aws_region}:${var.management_account_id}:trail/${var.trail_name}"
}

module "cloudtrail_bucket" {
  source = "../../../modules/aws/storage/s3"

  bucket_name         = var.bucket_name
  versioning_enabled  = true
  encryption_enabled  = true
  block_public_access = true

  tags = {
    Project = "landing-zone"
    Purpose = "cloudtrail-logs"
  }
}

module "cloudtrail_bucket_policy" {
  source = "../../../modules/aws/storage/s3-bucket-policy"

  bucket_id = module.cloudtrail_bucket.bucket_id

  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = module.cloudtrail_bucket.bucket_arn
        Condition = {
          StringEquals = { "aws:SourceArn" = local.trail_arn }
        }
      },
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource = [
          "${module.cloudtrail_bucket.bucket_arn}/AWSLogs/${var.management_account_id}/*",
          "${module.cloudtrail_bucket.bucket_arn}/AWSLogs/${var.organization_id}/*"
        ]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"  = "bucket-owner-full-control"
            "aws:SourceArn" = local.trail_arn
          }
        }
      }
    ]
  })

  depends_on = [module.cloudtrail_bucket]
}
