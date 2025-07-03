#!/bin/sh

sudo apt-get update
sudo apt-get install -y docker.io

sudo usermod -aG docker "$USER"

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
