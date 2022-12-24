terraform {
  backend "gcs" {
    bucket = "d7ed08f30a87921f-christmas-countdown-tfstate"
  }
}

provider "google" {
  project = "christmas-countdown-372221"
  region  = "us-central1"
}

resource "random_id" "tfstate_bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "tfstate" {
  name                     = "${random_id.tfstate_bucket_prefix.hex}-christmas-countdown-tfstate"
  force_destroy            = false
  location                 = "US"
  storage_class            = "STANDARD"
  public_access_prevention = "enforced"
  versioning {
    enabled = true
  }
}

resource "google_cloud_run_service" "christmas_countdown" {
  name     = "christmas-countdown"
  location = "us-central1"

  template {
    spec {
      containers {
        image = var.image
      }
    }
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.christmas_countdown.location
  project  = google_cloud_run_service.christmas_countdown.project
  service  = google_cloud_run_service.christmas_countdown.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
