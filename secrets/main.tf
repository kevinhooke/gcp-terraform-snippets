provider "google" {
  project = var.project_id
  region  = "europe-west2"
  zone    = "europe-west2-a"
}
resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret1"

  labels = {
    label = "my-label"
  }

  replication {
    auto {
    }
  }
}