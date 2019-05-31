resource "google_compute_network" "cf" {
  name                    = "cf"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cf_network" {
  name          = "cf-subnet"
  ip_cidr_range = "${var.cf_network_cidr}"
  network       = "${google_compute_network.cf.self_link}"
  region        = "${var.region}"
}

resource "google_compute_firewall" "internal" {
  name    = "internal"
  network = "${google_compute_network.cf.self_link}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = "${concat(list(var.cf_network_cidr))}"
}
