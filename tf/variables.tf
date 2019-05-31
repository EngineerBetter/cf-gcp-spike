variable "region" {}
variable "gcp_creds" {}
variable "project_id" {}
variable "domain" {}

variable "control_plane_cidr" {
  type    = "string"
  default = "10.0.0.0/22"
}

variable "cfar_cidr" {
  type    = "string"
  default = "10.0.4.0/22"
}
