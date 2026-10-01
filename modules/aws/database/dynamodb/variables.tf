variable "name_prefix" {
  type        = string
  description = "Base name used to build the table name (e.g. project or component name)"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment suffix appended to the name (e.g. dev, staging, prod)"
}

variable "override_table_name" {
  type        = string
  default     = ""
  description = "Force an exact table name instead of the computed name_prefix + environment"
}

variable "hash_key" {
  type        = string
  description = "Name of the hash key (partition key) attribute"
}

variable "hash_key_type" {
  type        = string
  default     = "S" # S = String, N = Number, B = Binary
  description = "Type of the hash key attribute"
}

variable "billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
  description = "Billing mode: PAY_PER_REQUEST (à l'usage) ou PROVISIONED (capacité fixe)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the table"
}