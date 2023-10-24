# Specify the provider (GCP, AWS, Azure)
provider "google" {
credentials = "${file("credentials.json")}"
project = "decent-essence-381907"
region = "us-central1"
}
