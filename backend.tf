terraform {
  backend "gcs" {
    bucket = "gluster-poc"
    prefix = "terraform/state"
  }
}
