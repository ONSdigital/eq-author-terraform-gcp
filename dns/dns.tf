locals {
  flattened_domains = flatten([
    for domain_key, domain_list in var.domains : [
      for domain in domain_list : "${domain}."
    ]
  ])
}

resource "google_dns_record_set" "resource-recordset" {
    count        = length(local.flattened_domains)
    project      = var.dns_project_id
    provider     = google-beta
    managed_zone = var.managed_zone_name
    name         = local.flattened_domains[count.index]
    type         = "A"
    rrdatas      = [var.load_balancer_address]
    ttl          = 300
}