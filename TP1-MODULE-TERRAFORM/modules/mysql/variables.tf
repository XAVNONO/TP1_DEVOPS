variable "mysql-instance_type" {
  type        = string
  default     = "e2-micro"
}
variable "hostname" {
  type        = string
  default     = "mysql"
}

variable "GCP_clessh" {
  type        = string
  default     = "ssh-ansible"
}

variable "GCP_project" {
  type        = string
  default     = "decent-essence-381907"
  description = "Le nom du projet GCP"
}

variable "GCP_zone" {
  type        = string
  default     = "us-central1-a"
  description = "La zone de déploiement"
}