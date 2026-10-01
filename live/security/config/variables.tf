variable "aws_region" {
  type        = string
  description = "Région AWS"
  default     = "eu-west-1"
}

variable "bucket_name" {
  type        = string
  description = "Nom du bucket S3 des logs Config (unique dans le monde)"
  default     = "jeremie-lz-config-logs"
}
