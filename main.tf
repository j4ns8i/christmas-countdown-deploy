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
