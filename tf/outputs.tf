output "service_account_key" {
  value = "${google_service_account_key.key.private_key}"
}

output "certificate" {
  value = "${tls_self_signed_cert.tls_cert.cert_pem}"
}

output "private_key" {
  value = "${tls_private_key.tls_key.private_key_pem}"
}
