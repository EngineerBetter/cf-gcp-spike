resource "google_service_account" "concourse" {
  account_id   = "concourse"
  display_name = "Concourse"
}

resource "google_project_iam_binding" "concourse-iam" {
  role = "roles/editor"

  members = [
    "serviceAccount:${google_service_account.concourse.email}",
  ]
}

resource "google_service_account_key" "key" {
  service_account_id = "${google_service_account.concourse.name}"
}

resource "google_service_account" "blobstore" {
  account_id   = "blobstore"
  display_name = "Blobstore Service Account"
}

resource "google_service_account_key" "blobstore" {
  service_account_id = "${google_service_account.blobstore.id}"
}

resource "google_project_iam_member" "blobstore_cloud_storage_admin" {
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.blobstore.email}"
}
