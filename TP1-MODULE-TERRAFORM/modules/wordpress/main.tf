resource "google_compute_instance" "wordpress-instance" {
  name          = "wordpress-instance"
  hostname      = var.hostname
  machine_type  = var.wordpress_instance_type
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
resource "google_compute_firewall" "wordpress_firewall" {
  name    = "wordpress-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80","443","22"]
  }
}
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["wordpress-instance"]

}

  metadata_startup_script = templatefile("wordpress_startup.sh", {
    mysql_ip  = module.mysql.vm_ip
    ssh_user  = var.GCP_clessh
  })

  tags = ["wordpress"]
}

data "template_file" "wordpress_startup" {
  template = file("wordpress_startup.tpl")
}

locals {
  startup_script = data.template_file.wordpress_startup.rendered
}

resource "google_compute_project_metadata_item" "wordpress_vm_metadata" {
  key   = "startup-script"
  value = local.startup_script
}