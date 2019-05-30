variable "region" {}
variable "gcp_creds" {}
variable "project_id" {}

provider "google" {
  credentials = "${var.gcp_creds}"
  project     = "${var.project_id}"
  region      = "${var.region}"
}

resource "google_service_account" "concourse" {
  account_id   = "concourse"
  display_name = "Concourse"
}

resource "google_service_account_iam_binding" "concourse-iam" {
  service_account_id = "${google_service_account.concourse.name}"
  role               = "roles/editor"

  members = [
    "serviceAccount:${google_service_account.concourse.email}",
  ]
}

resource "google_service_account_key" "key" {
  service_account_id = "${google_service_account.concourse.name}"
}

output "key" {
  value = "${google_service_account_key.key.public_key}"
}
