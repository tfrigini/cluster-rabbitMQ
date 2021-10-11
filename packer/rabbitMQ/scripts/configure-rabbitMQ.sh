#!/usr/bin/bash

## Disable IPV6
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf >/dev/null
echo "net.ipv4.tcp_tw_reuse = 1" | sudo tee -a /etc/sysctl.conf >/dev/null
echo "net.ipv4.tcp_fin_timeout = 1" | sudo tee -a /etc/sysctl.conf >/dev/null
sudo sysctl -p /etc/sysctl.conf

## Reiniciando o RabbitMQ
echo "Reiniciando o RabbitMQ"
sudo systemctl restart rabbitmq-server.service

echo "Waiting 30 secs for RabbitMQ to start"
sleep 30

## Adiciona um novo vhost
echo "Adiciona o vhost /main/"
sudo rabbitmqctl add_vhost /main/

## Configura algumas policies.
echo "Configura algumas policies."
sudo rabbitmqctl set_policy -p / qml-policy ".*" '{"queue-master-locator":"random"}'
sudo rabbitmqctl set_policy -p /main/ uae-policy ".*" '{"queue-master-locator":"random", "ha-mode": "all", "ha-sync-mode": "automatic"}'

## Enable rabbitMQ plugins
sudo rabbitmq-plugins --offline enable rabbitmq_peer_discovery_aws
sudo rabbitmq-plugins --offline enable rabbitmq_event_exchange
sudo rabbitmq-plugins --offline enable rabbitmq_federation
sudo rabbitmq-plugins --offline enable rabbitmq_federation_management
sudo rabbitmq-plugins --offline enable rabbitmq_management
sudo rabbitmq-plugins --offline enable rabbitmq_management_agent
sudo rabbitmq-plugins --offline enable rabbitmq_shovel
sudo rabbitmq-plugins --offline enable rabbitmq_shovel_management
sudo rabbitmq-plugins --offline enable rabbitmq_tracing


## Add configs
echo "Creating config files"
echo "cluster_formation.peer_discovery_backend = aws

cluster_formation.aws.region = AWS_REGION
# We'll use an AWS Role attached to instances to provide this access, if you want to use a IAM credential uncomment these lines
#cluster_formation.aws.access_key_id = AWS_ACCESS_KEY
#cluster_formation.aws.secret_key = AWS_SECRET_KEY

# Forcefully remove cluster members unknown to the peer discovery backend. Once removed,
# the nodes won't be able to rejoin. Use this mode with great care!
#
# This setting can only be used if a compatible peer discovery plugin is enabled.
cluster_formation.node_cleanup.only_log_warning = false

# perform the check every 90 seconds
cluster_formation.node_cleanup.interval = 90


cluster_formation.aws.use_autoscaling_group = true" | sudo tee -a /etc/rabbitmq/rabbitmq.conf >/dev/null

## Set a default value for erlang cookie, 
echo "XYZABCDFGHIJKLMNOUPQ" | sudo tee -a /var/lib/rabbitmq/.erlang.cookie >/dev/null

## Configure some folders to rabbitMQ user
echo "Configure some folders permissions to rabbitMQ user"
sudo chown rabbitmq.rabbitmq /var/lib/rabbitmq -R
sudo chown rabbitmq.rabbitmq /etc/rabbitmq -R
sudo chmod og-r /var/lib/rabbitmq/.erlang.cookie
sudo chmod u+r /var/lib/rabbitmq/.erlang.cookie

echo "Stopping rabbitMQ"
sudo systemctl stop rabbitmq-server.service

## Enable rabbitMQ on startup
echo "Enable rabbitMQ on startup"
sudo systemctl enable rabbitmq-server.service