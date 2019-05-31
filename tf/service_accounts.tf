resource "random_pet" "account-name" {
  length = 1
  prefix = "concourse"
}

resource "google_service_account" "concourse" {
  account_id   = "${random_pet.account-name.id}"
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
