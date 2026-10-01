variable "aws_region" {
  type        = string
  description = "Région AWS"
  default     = "eu-west-1"
}

variable "bucket_name" {
  type        = string
  description = "Nom du bucket S3 des logs CloudTrail (unique dans le monde)"
  default     = "jeremie-lz-cloudtrail-logs"
}

variable "trail_name" {
  type        = string
  description = "Nom du trail organisation (créé depuis Management)"
  default     = "org-trail"
}

variable "management_account_id" {
  type        = string
  description = "ID du compte Management"
  default     = "049211686207"
}

variable "organization_id" {
  type        = string
  description = "ID de l'Organization AWS"
  default     = "o-2vb5omhk1i"
}
