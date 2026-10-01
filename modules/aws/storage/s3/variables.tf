variable "versioning_enabled" {
  type        = bool
  default     = false
  description = "Enable versioning on the bucket"
}

variable "encryption_enabled" {
  type        = bool
  default     = false
  description = "Enable server-side encryption (AES256)"
}

variable "block_public_access" {
  type        = bool
  default     = false
  description = "Block all public access to the bucket"
}

variable "lifecycle_rules" {
  type = list(object({
    id                                 = string
    status                             = string
    prefix                             = optional(string)
    expiration_days                    = optional(number)
    noncurrent_version_expiration_days = optional(number)
  }))
  default     = []
  description = "Lifecycle rules for the bucket"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the bucket"
}
variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}
