resource "google_compute_security_policy" "policy" {
  name = "author-sec-policy"
  description = "cloud armour security policy for author"

  rule {
    action   = "allow"
    priority = "0"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = var.ons_ips
      }
    }
    description = "ONS IPs"
  }

  rule {
    action   = "allow"
    priority = "1"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = var.nat_ip
      }
    }
    description = "NAT IP"
  }

  rule {
    action   = "allow"
    priority = "99"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = var.developer_ips
      }
    }
    description = "Developer IPs"
  }

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default rule"
  }

  lifecycle {
    ignore_changes = all
  }
}