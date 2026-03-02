resource "google_iap_web_backend_service_iam_member" "member" {
  for_each = var.iap_applications
  web_backend_service = google_compute_backend_service.default[each.key].name
  role = "roles/iap.httpsResourceAccessor"
  member = "group:eq-services-prod@ons.gov.uk"
}