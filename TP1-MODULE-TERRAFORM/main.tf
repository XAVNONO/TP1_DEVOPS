provider "google" {
  credentials = file(var.GCP_identite)
  project     = var.GCP_project
  region      = var.GCP_region
  zone        = var.GCP_zone 
}

module "vpc" {
  source     = "./modules/vpc"
  vpc_name   = var.GCP_reseau
}

module "wordpress" {
  source     = "./modules/wordpress"
  subnet_id  = module.vpc.subnet_id
  ssh_user   = var.GCP_clessh
}

module "mysql" {
  source     = "./modules/mysql"
  subnet_id  = module.vpc.subnet_id
  ssh_user   = var.GCP_clessh
}
