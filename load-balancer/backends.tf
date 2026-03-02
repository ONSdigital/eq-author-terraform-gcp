resource "google_compute_backend_service" "default" {
  for_each                          = var.applications
  provider                          = google-beta
  backend {
    group          = google_compute_region_network_endpoint_group.default[each.key].id
    capacity_scaler = "0.0"
  }
  name                              = "${each.value.name}-service"
  protocol                          = "HTTP"
  connection_draining_timeout_sec   = "0"
  security_policy                   = "author-sec-policy"
}

resource "google_compute_region_network_endpoint_group" "default" {
  for_each = var.applications
  provider              = google-beta
  name                  = "${each.value.name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_run {
    service = each.value.name
  }
}
