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

resource "google_compute_firewall" "external" {
  name    = "external"
  network = "${google_compute_network.cf.name}"

  source_ranges = ["0.0.0.0/0"]

  allow {
    ports    = ["22", "6868", "25555"]
    protocol = "tcp"
  }

  target_tags = ["bosh-open"]
}

resource "google_compute_firewall" "bosh-open" {
  name    = "bosh-open"
  network = "${google_compute_network.bbl-network.name}"

  source_tags = ["bosh-open"]

  allow {
    ports    = ["22", "6868", "8443", "8844", "25555"]
    protocol = "tcp"
  }

  target_tags = ["bosh-director"]
}

resource "google_compute_firewall" "bosh-director" {
  name    = "bosh-director"
  network = "${google_compute_network.cf.name}"

  source_tags = ["bosh-director"]

  allow {
    protocol = "tcp"
  }

  target_tags = ["internal"]
}

resource "google_compute_firewall" "internal-to-director" {
  name    = "internal-to-director"
  network = "${google_compute_network.bbl-network.name}"

  source_tags = ["internal"]

  allow {
    ports    = ["4222", "25250", "25777"]
    protocol = "tcp"
  }

  target_tags = ["bosh-director"]
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

resource "google_compute_firewall" "bosh-open" {
  name    = "bosh-open"
  network = "${google_compute_network.cf.name}"

  source_tags = ["bosh-open"]

  allow {
    ports    = ["22", "6868", "8443", "8844", "25555"]
    protocol = "tcp"
  }

  target_tags = ["bosh-director"]
}

resource "google_compute_address" "director-ip" {
  name = "director-ip"
}
