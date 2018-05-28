Setup yours secrets at `terraform.tfvars` file

Running terraform

	$ docker-compose build && docker-compose up -d && docker exec -it mg-swarm-cluster bash

Setup a swarm cluster with one manager and two workers

	terraform init && terraform plan