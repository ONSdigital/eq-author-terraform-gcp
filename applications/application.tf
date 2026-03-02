
resource "google_cloud_run_v2_service" "default" {
  provider = google-beta
  for_each = var.applications
  name     = each.value.name
  location = var.region
  project  = var.project_id
  depends_on = [
    google_project_iam_member.editor,
    google_project_iam_member.secret_accessor,
    google_project_iam_member.datastore_user,
  ]
  invoker_iam_disabled = true
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  launch_stage = "GA"
  iap_enabled = contains(var.iap_applications, each.key) ? true : false
  template {
    service_account = google_service_account.cloud_run_service_account.email
    containers {
      image   = each.value.image
      args    = []
      command = []
      ports {
        container_port = each.value.container_port
      }
      resources {
        limits = {
          cpu    = each.value.cpu
          memory = each.value.memory
        }
      }
      dynamic "env" {
        for_each = each.value.envs
        content {
          name  = env.key
          value = env.value
        }
      }
      dynamic "env" {
        for_each = each.value.secrets
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = env.value
              version = "latest"
            }
          }
        }
      }
    }

    vpc_access {
      egress = "ALL_TRAFFIC"
      connector = var.connector_id
    }

    scaling {
        min_instance_count = 0
        max_instance_count = 100
    }

    labels = {}

  }

  lifecycle {
    //ignore_changes = all
  }
}