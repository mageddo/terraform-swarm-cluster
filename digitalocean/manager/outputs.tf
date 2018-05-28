output "manager_private_ip" {
  value = "${digitalocean_droplet.manager.0.ipv4_address_private}"
}

output "ips" {
  value = "${digitalocean_droplet.manager.*.ipv4_address}"
}

output "statuses" {
  value = "${digitalocean_droplet.manager.*.status}"
}

output "worker_join_token" {
  description = "Token to join in the docker swarm cluster"
  value = "${data.external.swarm_join_token.result.worker}"

}

output "join_token" {
  description = "Token to join in the docker swarm cluster"
  value = "${data.external.swarm_join_token.result.manager}"

}