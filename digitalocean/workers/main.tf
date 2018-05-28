provider "digitalocean" {
  token = "${var.api_token}"
}

resource "digitalocean_droplet" "worker" {
  count = "${var.count}"
  name = "${format("%s-%02d", "worker", count.index + 1)}"
  region = "${var.region}"
  size = "${var.size}"
  image = "${var.image}"
  ssh_keys = ["${var.ssh_keys}"]
  volume_ids = ["${var.volume_ids}"]

  connection {
    user = "root"
    type = "ssh"
    private_key = "${file(var.private_key_path)}"
    timeout = "2m"
  }
  private_networking = true
  tags = ["${sort(var.tags)}"]

  provisioner "remote-exec" {
    script = "${path.module}/../install-docker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token ${var.join_token} ${var.manager_ip}:2377"
    ]
  }

  # Handle clean up / destroy worker node
  # drain worker on destroy
  provisioner "remote-exec" {
    when = "destroy"

    inline = [
      "docker node update --availability drain ${self.name}",
    ]

    on_failure = "continue"

    connection {
      type = "ssh"
      user = "root"
      private_key = "${file("${var.private_key_path}")}"
      host = "${var.manager_ip}"
    }
  }

  # remove node on destroy
  provisioner "remote-exec" {
    when = "destroy"

    inline = [
      "docker node rm --force ${self.name}",
    ],

    on_failure = "continue"

    connection {
      type = "ssh"
      user = "root"
      private_key = "${file("${var.private_key_path}")}"
      host = "${var.manager_ip}"
    }
  }

  # leave swarm on destroy
  provisioner "remote-exec" {
    when = "destroy"

    inline = [
      "docker swarm leave",
    ]

    on_failure = "continue"
  }
}