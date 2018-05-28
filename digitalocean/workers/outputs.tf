output "ips" {
  value = "${digitalocean_droplet.worker.*.ipv4_address}"
}

output "statuses" {
  value = "${digitalocean_droplet.worker.*.status}"
}

