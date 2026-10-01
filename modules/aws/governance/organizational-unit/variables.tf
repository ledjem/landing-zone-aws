variable "name" {
  type        = string
  description = "OU Name"
}

variable "parent_id" {
  type        = string
  description = "Parent ID (root ID or another OU ID)"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}
