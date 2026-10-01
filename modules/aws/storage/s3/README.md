# Terraform AWS S3 Bucket Module

This module creates a secure and production-ready S3 bucket with modern AWS best practices:

* Ownership enforced (no ACLs)
* Optional versioning
* Public access fully blocked
* Tagging support

---

## Usage

```hcl
module "s3_bucket" {
  source = "../../modules/storage/s3"

  bucket_name        = "my-app-bucket"
  versioning_enabled = true

  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}
```

---

## Inputs

| Name               | Description                   | Type        | Default | Required |
| ------------------ | ----------------------------- | ----------- | ------- | -------- |
| bucket_name        | Name of the S3 bucket         | string      | n/a     | yes      |
| versioning_enabled | Enable or disable versioning  | bool        | true    | no       |
| tags               | Tags applied to the S3 bucket | map(string) | {}      | no       |

---

## Outputs

| Name                        | Description                        |
| --------------------------- | ---------------------------------- |
| bucket_id                   | ID of the S3 bucket                |
| bucket_arn                  | ARN of the S3 bucket               |
| bucket_name                 | Name of the S3 bucket              |


---

## Requirements

* Terraform >= 1.5.0
* AWS provider >= 5.0

---

## Features

* Secure by default (no public access)
* No legacy ACL usage
* Compatible with modern AWS S3 standards
* Easy to reuse across environments

---

## Notes

* This module uses **BucketOwnerEnforced**, which disables ACLs and relies only on IAM policies.
* Public access is fully blocked using S3 Public Access Block settings.
* Versioning is enabled by default but can be disabled.

---

## Example

```hcl
module "s3_bucket" {
  source = "../../modules/storage/s3"

  bucket_name = "prod-app-bucket"

  tags = {
    Environment = "prod"
    Owner       = "platform-team"
  }
}
```

---

## Author

Created as part of a Terraform modular infrastructure approach for reusable AWS components.
