variable "project_id" {
  description = "The ID of the project"
}

variable "region" {
  description = "The the region to use"
}

variable "applications" {
  description = "Application configurations"
}
variable "connector_id" {
  description = "The ID of the VPC Access Connector"
}

variable "iap_applications" {
  description = "List of applications to enable IAP for"
}