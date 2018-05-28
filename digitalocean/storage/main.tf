resource "digitalocean_volume" "default" {
  region      = "${var.region}"
  name        = "${var.name}"
  size        = "${var.size}" # sin in GB
  description = "Global persistence"
}
