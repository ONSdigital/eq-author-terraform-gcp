variable "domains" {
  description = "the domains to create certificates for"
}

variable "load_balancer_address" {
  description = "The the address of the load-balancer"
}

variable "dns_project_id" {
  description = "The ID of the DNS project"
}

variable "managed_zone_name" {
  description = "The zone of the DNS project"
}
