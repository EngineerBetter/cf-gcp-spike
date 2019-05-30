variable "region" {}
variable "gcp_creds" {}
variable "project_id" {}
variable "domain" {}

provider "google" {
  credentials = "${var.gcp_creds}"
  project     = "${var.project_id}"
  region      = "${var.region}"
}

resource "google_service_account" "concourse" {
  account_id   = "concourse"
  display_name = "Concourse"
}

resource "google_project_iam_binding" "concourse-iam" {
  role = "roles/editor"

  members = [
    "serviceAccount:${google_service_account.concourse.email}",
  ]
}

resource "google_service_account_key" "key" {
  service_account_id = "${google_service_account.concourse.name}"
}

resource "google_project_service" "compute_api" {
  service = "compute.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "dns_api" {
  service = "dns.googleapis.com"

  disable_dependent_services = true
}

resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "tls_cert" {
  key_algorithm   = "${tls_private_key.tls_key.algorithm}"
  private_key_pem = "${tls_private_key.tls_key.private_key_pem}"

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = [
    "*.${var.domain}",
    "*.apps.${var.domain}",
    "*.system.${var.domain}",
    "*.login.system.${var.domain}",
    "*.uaa.system.${var.domain}",
  ]

  subject {
    common_name = "*.${var.domain}"
  }
}

output "service_account_key" {
  value = "${google_service_account_key.key.private_key}"
}

output "certificate" {
  value = "${tls_self_signed_cert.tls_cert.cert_pem}"
}

output "private_key" {
  value = "${tls_private_key.tls_key.private_key_pem}"
}
