variable "region" {}
variable "gcp_creds" {}
variable "project_id" {}

provider "google" {
  credentials = "${var.gcp_creds}"
  project     = "${var.project_id}"
  region      = "${var.region}"
}

data "google_iam_policy" "editor" {
  binding {
    role = "roles/editor"

    members = [
      "serviceAccount:${google_service_account.concourse.email}",
    ]
  }
}

resource "google_service_account" "concourse" {
  account_id   = "concourse"
  display_name = "Concourse"
}

resource "google_service_account_iam_policy" "concourse-iam" {
  service_account_id = "${google_service_account.concourse.name}"

  policy_data = "${data.google_iam_policy.editor.policy_data}"
}

resource "google_service_account_key" "key" {
  service_account_id = "${google_service_account.concourse.name}"
}

resource "google_project_service" "compute_api" {
  service = "compute.googleapis.com"

  disable_dependent_services = true
}

output "key" {
  value = "${google_service_account_key.key.private_key}"
}
