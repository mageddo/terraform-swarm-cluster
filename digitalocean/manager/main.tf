provider "digitalocean" {
  token = "${var.api_token}"
}

resource "digitalocean_droplet" "manager" {
  name = "${format("%s-%02d", "manager", count.index + 1)}"
  count = "${var.count}"
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
      "if [ ${count.index} -eq 0 ]; then ip=${digitalocean_droplet.manager.0.ipv4_address_private};echo \"> creating cluster $ip\"; docker swarm init --advertise-addr $ip; fi"
    ]
  }
}

resource "null_resource" "bootstrap" {
  count = "${var.count}"

  triggers {
    cluster_instance_ids = "${join(",", digitalocean_droplet.manager.*.id)}"
  }

  connection {
    host = "${element(digitalocean_droplet.manager.*.ipv4_address, count.index)}"
    type = "ssh"
    user = "root"
    private_key = "${file(var.private_key_path)}"
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "if [ ${count.index} -gt 0 ] && [ ! `docker info | grep -q 'Swarm: active'` ]; then sudo docker swarm join --token ${var.join_token} ${element(digitalocean_droplet.manager.*.ipv4_address_private, 0)}:2377; exit 0; fi",
    ]
  }
}


# it recover manager join token
# https://www.terraform.io/docs/providers/external/data_source.html
data "external" "swarm_join_token" {
  program = ["python", "${path.module}/../get-join-tokens.py"]
  query = {
    hosts = "${join(",", digitalocean_droplet.manager.*.ipv4_address)}"
    user = "root"
    private_key = "${file(var.private_key_path)}"
  }
}