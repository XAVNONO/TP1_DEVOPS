resource "google_compute_network" "vpc_network" {
  name = var.reseau
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = var.sous_reseau
  ip_cidr_range = var.ip_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.name
}

output "subnet_id" {
  value = google_compute_subnetwork.vpc_subnet.id
}