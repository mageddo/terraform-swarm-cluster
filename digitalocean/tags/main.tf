provider "digitalocean" {
  token = "${var.api_token}"
}

resource "digitalocean_tag" "cluster" {
  name = "cluster"
}

resource "digitalocean_tag" "manager" {
  name = "manager"
}

resource "digitalocean_tag" "worker" {
  name = "worker"
}