variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "bucket_name" {
  description = "Bucket S3 central (Log Archive) pour les logs Config"
  type        = string
}

variable "organization_id" {
  description = "ID de l'AWS Organization autorisée à écrire"
  type        = string
}