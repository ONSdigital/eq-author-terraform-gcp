variable "project_id" {
  description = "The ID of the project"
}

variable "region" {
  description = "The the region to use"
  default = "europe-west2"
}

variable "domain_prefix" {
  description = "the prefix to use for the urls"
  default = "dev"
}

variable "ons_ips" {
  description = "The IP address for ons."
  type        = list(string)
}

variable "developer_ips" {
  description = "The IP address of the devs."
  type        = list(string)
}

variable "dns_project_id" {
  description = "The ID of the DNS project"
}

variable "managed_zone_name" {
  description = "The zone of the DNS project"
}
