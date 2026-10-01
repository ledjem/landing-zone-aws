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
    key            = "security/guardduty/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-landing-zone"
    encrypt        = true
  }
}

# Les ressources sont créées dans le compte Security (via le profil cross-account)
provider "aws" {
  region  = var.aws_region
  profile = "security"
}

# Le détecteur existe déjà : la délégation l'a activé automatiquement
data "aws_guardduty_detector" "this" {}

# Active GuardDuty automatiquement sur tous les comptes membres (existants et futurs)
resource "aws_guardduty_organization_configuration" "this" {
  detector_id                      = data.aws_guardduty_detector.this.id
  auto_enable_organization_members = "ALL"
}
