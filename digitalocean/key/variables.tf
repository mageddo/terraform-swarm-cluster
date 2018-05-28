variable "do_token" {
  description = "Your Digital Ocean API token"
}

variable "public_key_path" {
  description = "Path to the SSH public key to be used for authentication"
}

variable "ssh_key_name" {
  default = "terraform"
  description = "Name to save the ssh key"
}
