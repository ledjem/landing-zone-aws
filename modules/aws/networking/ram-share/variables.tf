variable "name" {
  description = "Nom du partage RAM"
  type        = string
}

variable "resource_arns" {
  description = "ARN des ressources à partager (subnets)"
  type        = list(string)
}

variable "principal_arns" {
  description = "ARN des OU ou comptes destinataires"
  type        = list(string)
}

variable "tags" {
  description = "Tags additionnels"
  type        = map(string)
  default     = {}
}
