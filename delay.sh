#!/bin/bash
sudo hostnamectl set-hostname ${nodename} &&
curl -sfL https://get.k3s.io | sh -s - server \
    --datastore-endpoint="mysql://${dbuser}:${dbpass}@tcp(${db_endpoint})/${dbname}" \
    --write-kubeconfig-mode 644 \
    --tls-san=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

while [ ! -f /etc/rancher/k3s/k3s.yaml ]; do
    echo -e "Waiting for k3s to bootstrap..."
    sleep 3
done