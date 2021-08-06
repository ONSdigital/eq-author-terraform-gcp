resource "google_compute_url_map" "default" {
    name        = "author-url-map"
    description = "author url mapping"

    default_service = google_compute_backend_service.default["author"].id
    dynamic "host_rule" {
        for_each = var.applications
        content {
            hosts = host_rule.value.hosts
            path_matcher = host_rule.key
        }
    }

    dynamic "path_matcher" {
        for_each = var.applications
        content {
            name = path_matcher.key
            default_service = google_compute_backend_service.default[path_matcher.value.default_service].id
            dynamic "path_rule" {
                for_each = path_matcher.value.path_rules
                content {
                    paths = path_rule.value.paths
                    service = google_compute_backend_service.default[path_rule.value.service].id
                }
            }
        }
    }
}

