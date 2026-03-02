variable "project_id" {
  description = "The ID of the project"
}

variable "region" {
  description = "The the region to use"
}

variable "applications" {
  description = "Application configurations"
}

variable "domains" {
  description = "the doains to create certificates for"
}

variable "iap_applications" {
  description = "the applications to grant IAP access to"
}
