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
    key            = "log-archive/config-bucket/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-landing-zone"
    encrypt        = true
  }
}