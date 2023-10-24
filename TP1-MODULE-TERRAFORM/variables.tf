variable "GCP_identite" {
  type        = string
  default     = "credentials.json"
  description = "Les paramètres d'authentification"
}

variable "GCP_project" {
  type        = string
  default     = "decent-essence-381907"
  description = "Le nom du projet GCP"
}

variable "GCP_region" {
  type        = string
  default     = "us-central1"
  description = "La région de déploiement"
}

variable "GCP_zone" {
  type        = string
  default     = "us-central1-a"
  description = "La zone de déploiement"
}

variable "GCP_reseau" {
  type        = string
  default     = "mon-reseau-vpc"
  description = "Le nom du réseau"
}

variable "GCP_clessh" {
  type        = string
  default     = "ssh-ansible"
  description = "La clé SSH nécessaire à Ansible"
}
