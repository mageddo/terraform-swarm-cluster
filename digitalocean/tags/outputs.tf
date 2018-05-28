output "cluster" {
  value = "${digitalocean_tag.cluster.id}"
}

output "manager" {
  value = "${digitalocean_tag.manager.id}"
}

output "worker" {
  value = "${digitalocean_tag.worker.id}"
}