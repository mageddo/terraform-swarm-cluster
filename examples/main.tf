module "tags" {
  source = "github.com/mageddo/terraform-swarm-cluster//digitalocean/tags"
  api_token = "${var.api_token}"
}

module "key" {
  source = "github.com/mageddo/terraform-swarm-cluster//digitalocean/key"
  do_token = "${var.api_token}"
  public_key_path = "${var.public_key_path}"
}

# https://github.com/thojkooi/terraform-digitalocean-docker-swarm-mode/issues/7#issuecomment-340261710
module "managers" {
  source = "github.com/mageddo/terraform-swarm-cluster//digitalocean/manager"

  count = "${var.managers}"
  image = "debian-9-x64"
  size = "1gb"

  join_token = "${module.managers.join_token}"
  tags = ["${module.tags.cluster}", "${module.tags.manager}"]

  api_token = "${var.api_token}"
  ssh_keys = "${module.key.id}"
  private_key_path = "${var.private_key_path}"
  public_key_path = "${var.public_key_path}"
  region = "${var.region}"
}

module "workers" {
  source = "github.com/mageddo/terraform-swarm-cluster//digitalocean/workers"

  count = "${var.workers}"
  image = "debian-9-x64"
  size = "1gb"

  manager_ip = "${module.managers.manager_private_ip}"
  join_token = "${module.managers.join_token}"
  tags = ["${module.tags.cluster}", "${module.tags.worker}"]

  api_token = "${var.api_token}"
  ssh_keys = "${module.key.id}"
  private_key_path = "${var.private_key_path}"
  public_key_path = "${var.public_key_path}"
  region = "${var.region}"
}

module "firewall" {
  source = "github.com/mageddo/terraform-swarm-cluster//digitalocean/firewall"
  api_token = "${var.api_token}"
  cluster_tags  = ["${module.tags.cluster}", "${module.tags.manager}", "${module.tags.worker}"]
  cluster_droplet_ids = []
  allowed_outbound_addresses = ["0.0.0.0/0"]
}

module "dns" {
  source = "github.com/mageddo/terraform-swarm-cluster//digitalocean/dns"

  api_token = "${var.api_token}"
  hostname = "server1.mageddo.com"
  main_ip = "${module.managers.ips[0]}"
  ips = "${flatten(list(module.managers.ips, module.workers.ips))}"
  size = "${var.managers + var.workers}"
}
