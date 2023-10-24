resource "google_compute_instance" "mysql-instance" {
  name          = "mysql-instance"
  hostname      = var.hostname
  machine_type  = var.mysql-instance_type
  project       = var.gcp_project
  zone          = var.gcp_zone

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-11-bullseye-v20230615"
      size  = 20
      type  = "pd-standard"
    }
  }

network_interface {
  network = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.vpc_subnet.name
  access_config {
    // Donner à la VM une adresse ip externe.
  }

###############################################################################
resource "google_compute_firewall" "mysql_firewall" {
  name    = "mysql-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["3306","22"]
  }
}
  source_tags   = ["wordpress-instance"]
  target_tags   = ["mysql-instance"]

}

  metadata_startup_script = templatefile("mysql_startup.sh", {
    ssh_user  = var.GCP_clessh
  })

  tags = ["mysql"]
}

data "template_file" "mysql_startup" {
  template = file("mysql_startup.tpl")
}

locals {
  startup_script = data.template_file.mysql_startup.rendered
}

resource "google_compute_project_metadata_item" "mysql_vm_metadata" {
  key   = "startup-script"
  value = local.startup_script
}