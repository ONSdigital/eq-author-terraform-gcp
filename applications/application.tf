
resource "google_cloud_run_service" "default" {
    provider = google-beta
    for_each = var.applications
    name     = each.value.name
    location = var.region
    project  = var.project_id

    template {
        spec {
            service_account_name = google_service_account.cloud_run_service_account.email
            containers {
                image = each.value.image
                ports {
                    container_port = each.value.container_port
                }
                dynamic "env" {
                    for_each = each.value.envs
                    content {
                        name = env.key
                        value = env.value
                    }
                }
                dynamic "env" {
                    for_each = each.value.secrets
                    content {
                        name = env.key
                        value_from {
                            secret_key_ref {
                                name = env.value
                                key = "latest"
                            }
                        }
                    }
                }
            }
        }
        metadata {
            annotations = {
                "autoscaling.knative.dev/maxScale"        = "100"
                "run.googleapis.com/vpc-access-egress"    = "all-traffic"
                "run.googleapis.com/vpc-access-connector" = "author-serverless-conn"
            }
        }
    }

    metadata {
        annotations = {
            "run.googleapis.com/ingress" = "internal-and-cloud-load-balancing"
            "run.googleapis.com/launch-stage" = "ALPHA"
        }
    }

    traffic {
        percent         = 100
        latest_revision = true
    }
    
    lifecycle {
        ignore_changes = [
        template[0].spec[0].containers[0].image
        ]
    }
}

resource "google_cloud_run_service_iam_policy" "default" {
    for_each = var.applications
    location    = var.region
    project     = var.project_id
    service     = each.value.name
    depends_on   = [google_cloud_run_service.default]
    policy_data = data.google_iam_policy.noauth.policy_data
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}