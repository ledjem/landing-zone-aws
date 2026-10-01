variable "aws_region" {
  type        = string
  description = "Région AWS"
  default     = "eu-west-1"
}

variable "security_email"   { type = string }
variable "logarchive_email" { type = string }
variable "workloads_email"  { type = string }
variable "network_email"    { type = string }
