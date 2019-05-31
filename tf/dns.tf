resource "google_dns_managed_zone" "default" {
  name        = "cf-zone"
  dns_name    = "${var.domain}."
  description = "DNS zone for CF"
}

resource "google_dns_record_set" "system" {
  name = "*.sys.${google_dns_managed_zone.default.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.default.name}"

  rrdatas = ["${google_compute_global_address.cf-address.address}"]
}

# resource "google_dns_record_set" "doppler-sys-dns" {
#   name = "doppler.sys.${var.domain}"
#   type = "A"
#   ttl  = 300

#   managed_zone = "${google_dns_managed_zone.default.name}"

#   rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_ws_address}"]
# }

# resource "google_dns_record_set" "loggregator-sys-dns" {
#   name = "loggregator.sys.${var.domain}"
#   type = "A"
#   ttl  = 300

#   managed_zone = "${google_dns_managed_zone.default.name}"

#   rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_ws_address}"]
# }

resource "google_dns_record_set" "wildcard-apps-dns" {
  name = "*.apps.${google_dns_managed_zone.default.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.default.name}"

  rrdatas = ["${google_compute_global_address.cf-address.address}"]
}

# resource "google_dns_record_set" "wildcard-ws-dns" {
#   name = "*.ws.${var.domain}"
#   type = "A"
#   ttl  = 300


#   managed_zone = "${google_dns_managed_zone.default.name}"


#   rrdatas = ["${var.internetless ? local.haproxy_static_ip : local.cf_ws_address}"]
# }


# resource "google_dns_record_set" "app-ssh-dns" {
#   name = "ssh.sys.${var.domain}"
#   type = "A"
#   ttl  = 300


#   managed_zone = "${google_dns_managed_zone.default.name}"


#   rrdatas = ["${var.internetless ? local.haproxy_static_ip : module.ssh-lb.address}"]
# }


# resource "google_dns_record_set" "tcp-dns" {
#   name = "tcp.${var.domain}"
#   type = "A"
#   ttl  = 300


#   managed_zone = "${google_dns_managed_zone.default.name}"


#   rrdatas = ["${var.internetless ? local.haproxy_static_ip : module.tcprouter.address}"]
# }

