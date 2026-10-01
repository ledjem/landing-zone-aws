variable "name" {
  description = "Account Name"
  type        = string
}

variable "email" {
  description = "Account Email"
  type        = string
}

variable "role_name" {
  description = "IAM role created in the new account for cross-account access from Management"
  type        = string
  default     = null
}

variable "parent_id" {
  description = "OU Account Parent"
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply"
}