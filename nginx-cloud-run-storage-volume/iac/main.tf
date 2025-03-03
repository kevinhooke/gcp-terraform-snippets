provider "google" {
  project = var.project_id
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

resource "google_cloud_run_v2_service" "nginx" {
  name     = "cloudrun-with-storage-volumes"

  location     = "europe-west2"
  deletion_protection = false
  ingress      = "INGRESS_TRAFFIC_ALL"

  template {
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"
    containers {
      image = "europe-west2-docker.pkg.dev/cloudrun-playground-435514/playground-repo/gcp-nginx-test:7"
      volume_mounts {
        name = "bucket1"
        mount_path = "/var/www/html"
      }
      volume_mounts {
        name = "bucket2"
        mount_path = "/var/www/html2"
      }

      startup_probe {
        initial_delay_seconds = 5
        timeout_seconds = 2
        period_seconds = 3
        failure_threshold = 5
        tcp_socket {
          port = 8080
        }
      }
      liveness_probe {
        http_get {
          path = "/"
        }
      }
    }
    vpc_access {
      network_interfaces {
        network    = "default"
        subnetwork = "default"
      }
    }

    volumes {
      name = "bucket1"
      gcs {
        bucket = google_storage_bucket.bucket1.name
        read_only = true
      }
    }
    volumes {
      name = "bucket2"
      gcs {
        bucket = google_storage_bucket.bucket2.name
        read_only = true
      }
    }

  }
}

resource "google_storage_bucket" "bucket1" {
  name          = "cloud-run-gcs-bucket1"
  location      = "EU"
}

resource "google_storage_bucket_object" "default" {
 name         = "index.html"
 source       = "../static/index.html"
 content_type = "text/plain"
 bucket       = google_storage_bucket.bucket1.id
}

resource "google_storage_bucket" "bucket2" {
  name          = "cloud-run-gcs-bucket2"
  location      = "EU"
}