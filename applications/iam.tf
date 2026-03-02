# create a service account for cloud run
resource "google_service_account" "cloud_run_service_account" {
  account_id   = "author-service-account"
  display_name = "Author Cloud Run Service Account"
}
resource "google_project_iam_member" "editor" {
  project  = var.project_id
  role   = "roles/run.admin"
  member = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

resource "google_project_iam_member" "secret_accessor" {
  project  = var.project_id
  role   = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

resource "google_project_iam_member" "datastore_user" {
  project  = var.project_id
  role   = "roles/datastore.user"
  member = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}
