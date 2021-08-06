locals {
  flattened_domains = flatten([
    for domain_key, domain_list in var.domains : [
      for domain in domain_list : "${domain}."
    ]
  ])
}

resource "google_dns_managed_zone" "parent-zone" {
  provider = google-beta
  name        = "eqbs-gcp-onsdigital-uk"
  dns_name    = "eqbs.gcp.onsdigital.uk."
  description = "DNS zone for Author"
}

resource "google_dns_record_set" "resource-recordset" {
    count        = length(local.flattened_domains)
    provider     = google-beta
    managed_zone = google_dns_managed_zone.parent-zone.name
    name         = local.flattened_domains[count.index]
    type         = "A"
    rrdatas      = [var.load_balancer_address]
    ttl          = 300
}