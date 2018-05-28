provider "digitalocean" {
  token = "${var.do_token}"
}

# Setup the public key
resource "digitalocean_ssh_key" "default" {
  name = "${var.ssh_key_name}"
  public_key = "${file(var.public_key_path)}"
}
