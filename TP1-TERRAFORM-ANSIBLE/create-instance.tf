# Création du réseau VPC
resource "google_compute_network" "vpc_network" {
  name                    = "my-network-vpc"
  auto_create_subnetworks = false
}

# Génération de la clé SSH pour Ansible
resource "tls_private_key" "ansible_ssh_private_key_file" {
  algorithm = "RSA"
  rsa_bits  = 4096
}



# Création du sous-réseau
resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "my-vpc-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = "10.0.0.0/24"
}

# Règles de pare-feu pour WordPress
resource "google_compute_firewall" "wordpress_firewall" {
  name    = "wordpress-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80","443","22"]
  }

  // Autoriser le trafic en provenance de partout vers les instances, avec une balise wordpress-instance
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["wordpress-instance"]
}

# Règles de pare-feu pour MySQL
resource "google_compute_firewall" "mysql_firewall" {
  name    = "mysql-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["3306","22"]
  }

  source_tags   = ["wordpress-instance"]
  target_tags   = ["mysql-instance"]
}

# Instance WordPress
resource "google_compute_instance" "wordpress_instance" {
  name         = "wordpress-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  tags         = ["wordpress-instance"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-11-bullseye-v20230615"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name

    access_config {
      // Donner à la VM une adresse ip externe.
    }
  }


  metadata = {
    ssh-keys = "xavnono:${tls_private_key.ansible_ssh_private_key_file.public_key_openssh}"
  }
}


# Instance MySQL
resource "google_compute_instance" "mysql_instance" {
  name         = "mysql-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  tags         = ["mysql-instance"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-11-bullseye-v20230615"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name
    access_config {
      // Donner à la VM une adresse ip externe.
    }
  }


  metadata = {
    ssh-keys = "xavnono:${tls_private_key.ansible_ssh_private_key_file.public_key_openssh}"
  }
}

output "wordpress_instance_ip" {
  value = "${google_compute_instance.wordpress_instance.network_interface.0.access_config.0.nat_ip}"
}

output "mysql_instance_ip" {
  value = "${google_compute_instance.mysql_instance.network_interface.0.access_config.0.nat_ip}"
}

output "private_key" {
  value = tls_private_key.ansible_ssh_private_key_file.private_key_pem
  sensitive = true
}


