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
    key            = "workloads/config/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-landing-zone"
    encrypt        = true
    profile        = "default"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "workloads"
}

module "config_recorder" {
  source = "../../../modules/aws/governance/config-recorder"

  bucket_name = var.bucket_name
  tags        = { Project = "landing-zone" }
}