provider "google" {
  project = var.project_id
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

resource "google_cloud_run_service" "default" {
  name     = "cloudrun-test1"
  location     = "europe-west2"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }
}
