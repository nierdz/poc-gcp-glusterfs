# Common
variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-c"
}

variable "project_name" {
  default = "gluster-poc"
}

variable "ssh_user" {
  default = "admin"
}

variable "ssh_pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable machine_type {
  default = "n1-standard-1"
}

variable disk_size {
  default = "50"
}

variable network {
  default = "default"
}

variable disk_type {
  default = "pd-standard"
}

variable node_count {
  default = 4
}

variable metadata {
  type    = "map"
  default = {}
}
