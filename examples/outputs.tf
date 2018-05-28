output "nodes_ips" {
  value = "${flatten(list(module.managers.ips, module.workers.ips))}"
}

output "nodes_statuses" {
  value = "${flatten(list(module.managers.statuses, module.workers.statuses))}"
}

output "api_token" {
  value = "${var.api_token}"
}

output "private_key" {
  value = "${file(var.private_key_path)}"
}
output "private_key_file" {
  value = "${var.private_key_path}"
}
