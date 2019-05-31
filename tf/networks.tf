resource "google_compute_network" "cf" {
  name                    = "cf"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "control_plane" {
  name          = "control_plane-subnet"
  ip_cidr_range = "${var.control_plane_cidr}"
  network       = "${google_compute_network.cf_network.self_link}"
  region        = "${var.region}"
}

resource "google_compute_subnetwork" "cfar" {
  name          = "cfar-subnet"
  ip_cidr_range = "${var.cfar_cidr}"
  network       = "${google_compute_network.cf_network.self_link}"
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

  source_ranges = "${concat(list(var.control_plane_cidr), var.internal_access_source_ranges)}"
}
