# create a service account for cloud run
resource "google_service_account" "cloud_run_service_account" {
  account_id   = "author-service-account"
  display_name = "Author Cloud Run Service Account"
}
resource "google_project_iam_member" "editor" {
  role   = "roles/run.admin"
  member = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

resource "google_project_iam_member" "secret_accessor" {
  role   = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

resource "google_project_iam_member" "datastore_user" {
  role   = "roles/datastore.user"
  member = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}
