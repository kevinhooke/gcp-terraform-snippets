provider "google" {
  project = var.project_id
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

resource "google_cloud_run_v2_service" "nginx" {
  name     = "cloudrun-with-volumes"

  location     = "europe-west2"
  deletion_protection = false
  ingress      = "INGRESS_TRAFFIC_ALL"

  template {
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"
    containers {
      image = "gcp-nginx-test europe-west2-docker.pkg.dev/cloudrun-playground-435514/playground-repo/gcp-nginx-test:2"
      #would be more appropriate to use GCP Storage instead of Filestore, but configuring here to test how to provision with Terraform
      volume_mounts {
        name       = "nfs"
        mount_path = "/var/www/html"
      }
    }
    vpc_access {
      network_interfaces {
        network    = "default"
        subnetwork = "default"
      }
    }

    volumes {
      name = "nfs"
      nfs {
        server    = google_filestore_instance.filestore.networks[0].ip_addresses[0]
        path      = "/share1"
        read_only = false
      }
    }
  }
}

resource "google_filestore_instance" "filestore" {
  name     = "cloudrun-filestore1"
  location = "europe-west2-a"
  tier     = "BASIC_HDD"

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}