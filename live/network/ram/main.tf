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
    key            = "infrastructure/network/ram/terraform.tfstate"
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

# Lit les outputs du state du VPC (dossier vpc/)
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "jeremie-lz-tfstate-base"
    key     = "infrastructure/network/vpc/terraform.tfstate"
    region  = "eu-west-1"
    profile = "default"
  }
}

module "share_subnets_workloads" {
  source = "../../../modules/aws/networking/ram-share"

  name          = "network-subnets-to-workloads"
  resource_arns = data.terraform_remote_state.vpc.outputs.subnet_arns

  principal_arns = [
    "arn:aws:organizations::049211686207:ou/o-2vb5omhk1i/ou-0ctf-w8acuoik",
  ]

  tags = {
    Project = "landing-zone"
  }
}