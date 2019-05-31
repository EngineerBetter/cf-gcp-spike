variable "ssl_certificate" {
  type = "string"
}

variable "ssl_certificate_private_key" {
  type = "string"
}

# output "router_backend_service" {
#   value = "${google_compute_backend_service.router-lb-backend-service.name}"
# }

output "router_lb_ip" {
  value = "${google_compute_global_address.cf-address.address}"
}

output "ssh_proxy_lb_ip" {
  value = "${google_compute_address.cf-ssh-proxy.address}"
}

# resource "google_compute_firewall" "firewall-cf" {
#   name       = "cf-open"
#   depends_on = ["google_compute_network.cf"]
#   network    = "${google_compute_network.cf.name}"

#   allow {
#     protocol = "tcp"
#     ports    = ["80", "443"]
#   }

#   source_ranges = ["0.0.0.0/0"]

#   target_tags = ["${google_compute_backend_service.router-lb-backend-service.name}"]
# }

resource "google_compute_global_address" "cf-address" {
  name = "cf"
}

resource "google_compute_global_forwarding_rule" "cf-http-forwarding-rule" {
  name       = "cf-http"
  ip_address = "${google_compute_global_address.cf-address.address}"
  target     = "${google_compute_target_http_proxy.cf-http-lb-proxy.self_link}"
  port_range = "80"
}

resource "google_compute_global_forwarding_rule" "cf-https-forwarding-rule" {
  name       = "cf-https"
  ip_address = "${google_compute_global_address.cf-address.address}"
  target     = "${google_compute_target_https_proxy.cf-https-lb-proxy.self_link}"
  port_range = "443"
}

resource "google_compute_target_http_proxy" "cf-http-lb-proxy" {
  name        = "http-proxy"
  description = "really a load balancer but listed as an http proxy"
  url_map     = "${google_compute_url_map.cf-https-lb-url-map.self_link}"
}

resource "google_compute_target_https_proxy" "cf-https-lb-proxy" {
  name             = "https-proxy"
  description      = "really a load balancer but listed as an https proxy"
  url_map          = "${google_compute_url_map.cf-https-lb-url-map.self_link}"
  ssl_certificates = ["${google_compute_ssl_certificate.cf-cert.self_link}"]
}

resource "google_compute_ssl_certificate" "cf-cert" {
  name_prefix = "cf"
  description = "user provided ssl private key / ssl certificate pair"
  private_key = "${var.ssl_certificate_private_key}"
  certificate = "${var.ssl_certificate}"

  lifecycle {
    create_before_destroy = true
  }
}

# resource "google_compute_url_map" "cf-https-lb-url-map" {
#   name = "cf-http"

#   default_service = "${google_compute_backend_service.router-lb-backend-service.self_link}"
# }

resource "google_compute_health_check" "cf-public-health-check" {
  name = "cf-public"

  http_health_check {
    port         = 8080
    request_path = "/health"
  }
}

resource "google_compute_http_health_check" "cf-public-health-check" {
  name         = "cf"
  port         = 8080
  request_path = "/health"
}

# resource "google_compute_firewall" "cf-health-check" {
#   name       = "cf-health-check"
#   depends_on = ["google_compute_network.cf"]
#   network    = "${google_compute_network.cf.name}"

#   allow {
#     protocol = "tcp"
#     ports    = ["8080", "80"]
#   }

#   source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
#   target_tags   = ["${google_compute_backend_service.router-lb-backend-service.name}"]
# }

output "ssh_proxy_target_pool" {
  value = "${google_compute_target_pool.cf-ssh-proxy.name}"
}

resource "google_compute_address" "cf-ssh-proxy" {
  name = "cf-ssh-proxy"
}

resource "google_compute_firewall" "cf-ssh-proxy" {
  name       = "cf-ssh-proxy-open"
  depends_on = ["google_compute_network.cf"]
  network    = "${google_compute_network.cf.name}"

  allow {
    protocol = "tcp"
    ports    = ["2222"]
  }

  target_tags = ["${google_compute_target_pool.cf-ssh-proxy.name}"]
}

resource "google_compute_target_pool" "cf-ssh-proxy" {
  name = "cf-ssh-proxy"

  session_affinity = "NONE"
}

resource "google_compute_forwarding_rule" "cf-ssh-proxy" {
  name        = "cf-ssh-proxy"
  target      = "${google_compute_target_pool.cf-ssh-proxy.self_link}"
  port_range  = "2222"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf-ssh-proxy.address}"
}
