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

module "config_recorder" {
  source = "../../../modules/aws/governance/config-recorder"

  bucket_name = var.bucket_name
  tags        = { Project = "landing-zone" }
}

# Les ressources existantes changent d'adresse, elles ne sont pas recréées
moved {
  from = module.config_role
  to   = module.config_recorder.module.role
}

moved {
  from = aws_config_configuration_recorder.this
  to   = module.config_recorder.aws_config_configuration_recorder.this
}

moved {
  from = aws_config_delivery_channel.this
  to   = module.config_recorder.aws_config_delivery_channel.this
}

moved {
  from = aws_config_configuration_recorder_status.this
  to   = module.config_recorder.aws_config_configuration_recorder_status.this
}