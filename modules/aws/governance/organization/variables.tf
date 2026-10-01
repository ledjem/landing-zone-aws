variable "feature_set" {
  type        = string
  description = "ALL (enables SCP) or CONSOLIDATED_BILLING"
  default     = "ALL"
}

variable "aws_service_access_principals" {
  type        = list(string)
  description = "AWS services allowed to integrate with Organizations (e.g. cloudtrail.amazonaws.com)"
  default     = []
}

variable "enabled_policy_types" {
  type        = list(string)
  description = "Policy types to enable at the root (e.g. SERVICE_CONTROL_POLICY)"
  default     = []
}
