variable "aws_region" {
  description = "Région AWS où déployer le backend"
  type        = string
  default     = "eu-west-1"
}

variable "state_bucket_name" {
  description = "Nom du bucket S3 (doit être globalement unique sur AWS)"
  type        = string
}