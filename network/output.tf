output "nat_ip" {
  description = "The IP address of the nat."
  value       = google_compute_address.default.address
}