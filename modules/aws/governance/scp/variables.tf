variable "name" {
  type        = string
  description = "SCP Name"
}

variable "policy_json" {
  type        = string
  description = "JSON content of the policy"
}

variable "target_id" {
  type        = string
  description = "OU or account ID to attach the SCP to"
}

variable "type" {
  type        = string
  description = "Policy type"
  default     = "SERVICE_CONTROL_POLICY"
}