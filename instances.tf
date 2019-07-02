resource "google_compute_disk" "gluster-disk" {
  count = "${var.node_count}"
  name  = "gluster-disk${count.index}-data"
  type  = "${var.disk_type}"
  zone  = "${var.zone}"
  size  = "${var.disk_size}"
}

resource "google_compute_instance" "gluster-" {
  count        = "${var.node_count}"
  name         = "gluster-${count.index}"
  machine_type = "${var.machine_type}"
  tags         = ["allow-ssh"]
  zone         = "${var.zone}"

  network_interface {
    network = "${var.network}"
    access_config {
    }
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      image = "debian-9-stretch-v20190618"
      type  = "${var.disk_type}"
    }
  }

  attached_disk {
    source = "${element(google_compute_disk.gluster-disk.*.self_link, count.index)}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  metadata = "${merge(
    map("startup-script", "${file("${path.module}/scripts/startup.sh")}", "sshKeys", "${var.ssh_user}:${file(var.ssh_pub_key)}"),
    var.metadata
  )}"
}
