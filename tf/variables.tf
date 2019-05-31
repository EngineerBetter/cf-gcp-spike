variable "region" {}
variable "gcp_creds" {}
variable "project_id" {}
variable "domain" {}

variable "cf_network_cidr" {
  type    = "string"
  default = "10.0.0.0/22"
}
