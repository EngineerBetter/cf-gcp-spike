resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "tls_cert" {
  key_algorithm         = "${tls_private_key.tls_key.algorithm}"
  private_key_pem       = "${tls_private_key.tls_key.private_key_pem}"
  validity_period_hours = 8760

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
