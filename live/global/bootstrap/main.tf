terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "state_bucket" {
  source = "../../../modules/aws/storage/s3"

  bucket_name         = var.state_bucket_name
  versioning_enabled  = true
  encryption_enabled  = true
  block_public_access = true

  tags = {
    Project = "landing-zone"
    Purpose = "terraform-state"
  }
}

module "lock_table" {
  source = "../../../modules/aws/database/dynamodb"

  name_prefix          = "landing-zone-locks"
  environment          = "global"
  override_table_name  = "terraform-locks-landing-zone"
  hash_key             = "LockID"

  tags = {
    Project = "landing-zone"
    Purpose = "terraform-lock"
  }
}
