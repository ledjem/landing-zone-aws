variable "name_prefix" {
  description = "Base name prefix for resources"
  type        = string
}

variable "environment" {
  description = "Environment suffix (dev, qa, prod...)"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of availability zones to place subnets in (optional)"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "enable_nat_gateway" {
  description = "Create NAT gateways for private subnets (adds cost)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "enable_flow_logs" {
  description = "Set to true to enable VPC Flow Logs to CloudWatch."
  type        = bool
  default     = false
}

variable "flow_logs_retention_in_days" {
  description = "Number of days to retain VPC Flow Logs in CloudWatch."
  type        = number
  default     = 14
}

variable "flow_logs_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL."
  type        = string
  default     = "ALL"
  
  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_logs_traffic_type)
    error_message = "The flow_logs_traffic_type must be one of: ACCEPT, REJECT, ALL."
  }
}
variable "kms_key_id" {
  description = "The KMS key ID to encrypt the CloudWatch Log Group"
  type        = string
  default     = null
}