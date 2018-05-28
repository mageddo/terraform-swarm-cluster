variable "api_token" {
  description = "Your Digital Ocean API token"
}

variable "public_key_path" {
  description = "Path to the SSH public key to be used for authentication"
}

variable "private_key_path" {
  description = "Path to the SSH public key to be used for authentication"
}

variable "count" {
  default = 1
  description = "Quantity of cluster managers, use even numbers eg. 1,3,5,7"
}

variable "join_token" {
  description = "Token to join to the cluster"
}

variable "ssh_keys" {
  type = "list"
}

variable "tags" {
  type = "list"
  default = []
}

variable "volume_ids" {
  type = "list"
  default = []
}


variable "size" {}

variable "image" {}

variable "region" {}

variable "manager_ip" {}
