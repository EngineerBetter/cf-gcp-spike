output "service_account_key" {
  value = "${google_service_account_key.key.private_key}"
}

output "certificate" {
  value = "${tls_self_signed_cert.tls_cert.cert_pem}"
}

output "private_key" {
  value = "${tls_private_key.tls_key.private_key_pem}"
}

output "internal_gw" {
  value = "${google_compute_subnetwork.cf_network.gateway_address}"
}

output "internal_cidr" {
  value = "${var.cf_network_cidr}"
}

output "internal_ip" {
  value = "${cidrhost(var.cf_network_cidr, 6)}"
}

output "director_ip" {
  value = "${google_compute_address.director-ip.address}"
}

output "director_tags" {
  value = ["${google_compute_firewall.bosh-director.name}"]
}

output "internal_tag_name" {
  value = "${google_compute_firewall.internal.name}"
}
