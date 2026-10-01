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
    key            = "infrastructure/network/vpc/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-landing-zone"
    profile        = "default"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  profile = "network"
}

module "vpc" {
  source = "../../../modules/aws/networking/vpc"

  name_prefix = "network"
  environment = ""
  cidr        = "10.0.0.0/16"

  azs                  = ["eu-west-1a", "eu-west-1b"]
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs  = []

  enable_nat_gateway = false
  enable_flow_logs   = false
  kms_key_id         = null

  tags = {
    Project = "landing-zone"
  }
}