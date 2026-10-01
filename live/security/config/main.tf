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
    key            = "security/config/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-landing-zone"
    encrypt        = true
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "security"
}

# Bucket S3 qui reçoit les snapshots de configuration
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
        Action    = "s3:GetBucketAcl"
        Resource  = module.config_bucket.bucket_arn
      },
      {
        Sid       = "AWSConfigBucketDelivery"
        Effect    = "Allow"
        Principal = { Service = "config.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${module.config_bucket.bucket_arn}/*"
        Condition = {
          StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" }
        }
      }
    ]
  })

  depends_on = [module.config_bucket]
}

# Rôle IAM que Config utilise pour lire les ressources et écrire les logs
module "config_role" {
  source = "../../../modules/aws/identity/iam-role"

  role_name            = "config-recorder-role"
  assume_role_services = ["config.amazonaws.com"]
  managed_policy_arns  = ["arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"]

  tags = {
    Project = "landing-zone"
  }
}

# Le recorder : commence à observer les ressources du compte
resource "aws_config_configuration_recorder" "this" {
  name     = "default"
  role_arn = module.config_role.role_arn

  recording_group {
    all_supported = true
  }
}

# Où envoyer les enregistrements
resource "aws_config_delivery_channel" "this" {
  name           = "default"
  s3_bucket_name = module.config_bucket.bucket_id

  depends_on = [module.config_bucket_policy]
}

# Démarre vraiment l'enregistrement
resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.this]
}
