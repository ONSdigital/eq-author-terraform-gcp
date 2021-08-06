resource "google_compute_managed_ssl_certificate" "default" {
  for_each = var.domains
  name = "author-cert-${each.key}"
  managed {
    domains = each.value
  }
}
