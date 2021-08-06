variable "project_id" {
  description = "The ID of the project"
}

variable "nat_ip" {
  description = "The IP address of the nat."
  type        = list(string)
}

variable "ons_ips" {
  description = "The IP address for ONS."
  type        = list(string)
}

variable "developer_ips" {
  description = "The IP address of the devs."
  type        = list(string)
}