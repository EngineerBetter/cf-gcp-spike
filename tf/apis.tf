resource "google_project_service" "compute_api" {
  service = "compute.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "dns_api" {
  service = "dns.googleapis.com"

  disable_dependent_services = true
}
