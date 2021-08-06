resource "google_compute_forwarding_rule" "redirect" {
  name       = "author-redirect-forwarding-rule"
  ip_protocol  = "TCP"
  ip_address = google_compute_address.load_balancer.address
  target     = google_compute_target_http_proxy.redirect.id
  port_range = 80
  network_tier = "STANDARD"
}

resource "google_compute_target_http_proxy" "redirect" {
  name             = "author-redirect-target-proxy"
  url_map          = google_compute_url_map.redirect.id
}

resource "google_compute_url_map" "redirect" {
  name        = "author-redirect-map"
  description = "author redirect url mapping"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}
