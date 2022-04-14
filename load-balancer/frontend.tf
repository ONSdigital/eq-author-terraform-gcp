resource "google_compute_address" "load_balancer" {
  name      = "author-lb-external-ip"
  region    = var.region
  network_tier = "STANDARD"
}

resource "google_compute_forwarding_rule" "default" {
  name       = "author-forwarding-rule"
  ip_protocol  = "TCP"
  ip_address = google_compute_address.load_balancer.address
  target     = google_compute_target_https_proxy.default.id
  port_range = 443
  network_tier = "STANDARD"
}

resource "google_compute_target_https_proxy" "default" {
  name             = "author-target-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_policy       = google_compute_ssl_policy.default-ssl-policy.id
  ssl_certificates = values(google_compute_managed_ssl_certificate.default)[*].id
}

resource "google_compute_ssl_policy" "default-ssl-policy" {
  name            = "author-ssl-policy"
  profile         = "RESTRICTED"
  min_tls_version = "TLS_1_2"
}
