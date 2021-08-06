variable "project_id" {
  description = "The ID of the project"
}

variable "region" {
  description = "The the region to use"
}

variable "domain_prefix" {
  description = "the prefix to use for the urls"
}

variable "ons_ips" {
  description = "The IP address for ons."
  type        = list(string)
}

variable "developer_ips" {
  description = "The IP address of the devs."
  type        = list(string)
}
