#!/bin/bash
# Setup script for AWS EC2 Ubuntu instance
# Run this after SSH-ing into your instance

set -e

echo "=== Updating system ==="
sudo apt-get update && sudo apt-get upgrade -y

echo "=== Installing Docker ==="
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER

echo "=== Installing Docker Compose ==="
sudo apt-get install -y docker-compose-plugin

echo "=== Installing git ==="
sudo apt-get install -y git

echo "=== Done! ==="
echo ""
echo "Next steps:"
echo "1. Log out and back in (for docker group permissions)"
echo "2. Clone the repo:  git clone https://github.com/YOUR_USER/hlfun.git"
echo "3. cd hlfun && docker compose up -d"
echo "4. Share the URL with your friends!"
