#!/bin/bash

set -e

echo "> installing curl"
apt-get update && apt-get install -y curl

echo "> installing docker"
curl -fsSL https://get.docker.com/ | sh