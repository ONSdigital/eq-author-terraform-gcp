output "load_balancer_address" {
  description = "The IP address of the instance."
  value       = google_compute_address.load_balancer.address
}