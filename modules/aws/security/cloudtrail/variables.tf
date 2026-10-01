variable "name" {
  type        = string
  description = "Nom du trail"
}

variable "s3_bucket_name" {
  type        = string
  description = "Nom du bucket S3 qui reçoit les logs"
}

variable "is_organization_trail" {
  type        = bool
  description = "Si true, le trail s'applique à tous les comptes de l'Organization"
  default     = false
}

variable "is_multi_region_trail" {
  type        = bool
  description = "Si true, capture les événements dans toutes les régions"
  default     = true
}

variable "enable_log_file_validation" {
  type        = bool
  description = "Active la validation d'intégrité des fichiers de log"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags à appliquer"
  default     = {}
}
