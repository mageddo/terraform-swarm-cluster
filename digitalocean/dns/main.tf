provider "digitalocean" {
  token = "${var.api_token}"
}

resource "digitalocean_domain" "default" {
  name       = "${var.hostname}"
  ip_address = "${var.main_ip}"
}

# Add a record to the domain
resource "digitalocean_record" "default" {
  count  = "${var.size}"
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "@"
  value  = "${element(var.ips, count.index)}"
  ttl = 60
}