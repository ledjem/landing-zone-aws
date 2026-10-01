variable "role_name" {
  description = "The name of the IAM role."
  type        = string
}

variable "role_description" {
  description = "The description of the IAM role."
  type        = string
  default     = null
}

variable "assume_role_services" {
  description = "A list of AWS services that can assume this role (e.g., ['ec2.amazonaws.com'])."
  type        = list(string)
}

variable "managed_policy_arns" {
  description = "A list of managed policy ARNs to attach to the role."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to the role."
  type        = map(string)
  default     = {}
}