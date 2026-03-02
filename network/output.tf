output "nat_ip" {
  description = "The IP address of the nat."
  value       = google_compute_address.default.address
}

output "vpc_connector_id" {
  description = "The ID of the VPC Access Connector."
  value       = google_vpc_access_connector.connector.id
}

output project_number {
  description = "The project number."
  value       = module.project-services.project_number
}