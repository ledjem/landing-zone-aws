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
    key            = "organizations/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks-landing-zone"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# ---------------------------------------------------------------------------
# Active AWS Organizations (une seule fois)
# ---------------------------------------------------------------------------
module "organization" {
  source = "../../../modules/aws/governance/organization"

  feature_set          = "ALL"
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "securityhub.amazonaws.com",
    "guardduty.amazonaws.com",
    "ram.amazonaws.com",
  ]

}
# ---------------------------------------------------------------------------
# Active RAM (Resources Acces Management)
# ---------------------------------------------------------------------------
resource "aws_ram_sharing_with_organization" "this" {
  depends_on = [module.organization]
}
# ---------------------------------------------------------------------------
# Organizational Units
# ---------------------------------------------------------------------------
module "security_ou" {
  source = "../../../modules/aws/governance/organizational-unit"

  name      = "Security"
  parent_id = module.organization.root_id
}

module "workloads_ou" {
  source = "../../../modules/aws/governance/organizational-unit"

  name      = "Workloads"
  parent_id = module.organization.root_id
}

module "infrastructure_ou" {
  source = "../../../modules/aws/governance/organizational-unit"

  name      = "Infrastructure"
  parent_id = module.organization.root_id
}

# ---------------------------------------------------------------------------
# Comptes membres
# ---------------------------------------------------------------------------
module "security_account" {
  source = "../../../modules/aws/governance/account"

  name      = "Security"
  email     = var.security_email
  parent_id = module.security_ou.id

  tags = {
    Project = "landing-zone"
  }
}

module "log_archive_account" {
  source = "../../../modules/aws/governance/account"

  name      = "Log Archive"
  email     = var.logarchive_email
  parent_id = module.security_ou.id

  tags = {
    Project = "landing-zone"
  }
}

module "workloads_account" {
  source = "../../../modules/aws/governance/account"

  name      = "Workloads"
  email     = var.workloads_email
  parent_id = module.workloads_ou.id

  tags = {
    Project = "landing-zone"
  }
}

module "network_account" {
  source = "../../../modules/aws/governance/account"

  name      = "Network"
  email     = var.network_email
  parent_id = module.infrastructure_ou.id

  tags = {
    Project = "landing-zone"
  }
}

# ---------------------------------------------------------------------------
# SCP
# ---------------------------------------------------------------------------
module "scp_deny_cloudtrail" {
  source = "../../../modules/aws/governance/scp"

  name      = "Block_Remove_CloudTrail"
  target_id = module.security_ou.id

  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyCloudTrailDisable"
        Effect = "Deny"
        Action = [
          "cloudtrail:StopLogging",
          "cloudtrail:DeleteTrail"
        ]
        Resource = "*"
      }
    ]
  })

  depends_on = [module.organization]
}

module "scp_deny_outside_eu_west_1" {
  source = "../../../modules/aws/governance/scp"

  name      = "Deny_Outside_EuWest1"
  target_id = module.workloads_ou.id

  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyOutsideEuWest1"
        Effect = "Deny"
        NotAction = [
          "iam:*",
          "organizations:*",
          "route53:*",
          "cloudfront:*",
          "support:*",
          "sts:*"
        ]
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = "eu-west-1"
          }
        }
      }
    ]
  })

  depends_on = [module.organization]
}

module "scp_deny_deletion_security_hub" {
  source = "../../../modules/aws/governance/scp"

  name      = "Deny_Deletion_SecurityHub"
  target_id = module.security_ou.id

  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenySupressionSecurityHub"
        Effect = "Deny"
        Action = [
          "securityhub:DisableSecurityHub",
          "securityhub:DisableSecurityHubV2"
        ]
        Resource = "*"
      }

    ]
  })

  depends_on = [module.organization]
}

module "scp_deny_deletion_vpc" {
  source = "../../../modules/aws/governance/scp"

  name      = "Deny_Deletion_Vpc"
  target_id = module.infrastructure_ou.id

  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenySupressionVpc"
        Effect = "Deny"
        Action = [
          "ec2:DeleteVpc"
        ]
        Resource = "*"
      }

    ]
  })

  depends_on = [module.organization]
}

# ---------------------------------------------------------------------------
# Delegated admin GuardDuty (Security)
# ---------------------------------------------------------------------------
module "guardduty_admin" {
  source = "../../../modules/aws/security/guardduty-organization-admin"

  admin_account_id = module.security_account.account_id

  depends_on = [module.organization]
}
# ---------------------------------------------------------------------------
# Trail CloudTrail organisation (écrit dans le bucket de Log Archive)
# ---------------------------------------------------------------------------
module "org_trail" {
  source = "../../../modules/aws/security/cloudtrail"

  name                  = "org-trail"
  s3_bucket_name        = "jeremie-lz-cloudtrail-logs"
  is_organization_trail = true

  tags = {
    Project = "landing-zone"
  }

  depends_on = [module.organization]
}

# ---------------------------------------------------------------------------
# Delegated admin Security Hub (Security)
# ---------------------------------------------------------------------------
module "securityhub_admin" {
  source = "../../../modules/aws/security/securityhub-organization-admin"

  admin_account_id = module.security_account.account_id

  depends_on = [module.organization]
}
# ---------------------------------------------------------------------------
# Delegated Config (Security)
# ---------------------------------------------------------------------------
module "config_admin" {
  source = "../../../modules/aws/governance/delegated-administrator"

  account_id        = module.security_account.account_id
  service_principal = "config.amazonaws.com"

  depends_on = [module.organization]
}


