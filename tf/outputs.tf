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
  value = "${google_compute_subnetwork.control_plane.gateway_address}"
}

output "internal_cidr" {
  value = "${var.control_plane_cidr}"
}

output "internal_ip" {
  value = "${cidrhost(var.control_plane_cidr, 6)}"
}
