variable "bucket_name" {
  description = "Bucket S3 central (Log Archive) pour les logs Config"
  type        = string
}

variable "role_name" {
  type    = string
  default = "config-recorder-role"
}

variable "tags" {
  type    = map(string)
  default = {}
}