data "aws_region" "current_region" {}

locals {
  region = "eu-central-1"
  rmq_admin_password = yamldecode(file("${path.module}/secrets/${terraform.workspace}/rabbitmq.yaml"))["admin_pass"]
  ERLANG_TOKEN = yamldecode(file("${path.module}/secrets/${terraform.workspace}/erlang.yaml"))["token"]

  rabbitmq_lb = {
    development = {
      subnets         = slice(module.vpc.public_subnets, 0, 3)
      security_groups = [module.rabbitmq-sg.security_group_id]
    }
  }

  user_data = <<-EOT
#!/bin/bash
echo "Setting erlang Token"
echo "${local.ERLANG_TOKEN}" | tee /var/lib/rabbitmq/.erlang.cookie >/dev/null

## Set configurations to rabbitmq_peer_discovery_aws plugin
echo "Setting configs for RabbitMQ"
sed -i 's/AWS_REGION/${data.aws_region.current_region.name}/' /etc/rabbitmq/rabbitmq.conf

## Reinicia o serviço do RabbitMQ ao finalizar as configurações
echo "Restarting rabbitmq"
systemctl restart rabbitmq-server.service
sleep 30

## Cria um novo usuario administrador
echo "Creating admin user"
rabbitmqctl add_user admin ${local.rmq_admin_password}
rabbitmqctl set_user_tags admin administrator
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
  EOT

  asg_rabbit_mq = {
    development = {
      name                = "RabbitMQ"
      subnets             = slice(module.vpc.private_subnets, 0, 3)
      ssh_key             = "aws-infra-dev"
      capacity_rebalance  = false
      security_groups     = [module.rabbitmq-sg.security_group_id]
    }
  }
}

data "aws_ami" "rabbitmq-image" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["rabbitMQ-cluster-*"]
  }
}

resource "aws_iam_instance_profile" "rabbit_role" {
  name = "${local.asg_rabbit_mq[terraform.workspace].name}-instance-profile"
  role = aws_iam_role.rabbitMQ_role.name

  tags = {}
}

module "asg_rabbitmq" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.4.0"

  create_asg = false

  # Autoscaling group
  name =  "Cluster-${local.asg_rabbit_mq[terraform.workspace].name}-ASG"

  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  capacity_rebalance        = local.asg_rabbit_mq[terraform.workspace].capacity_rebalance
  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"
  vpc_zone_identifier       = local.asg_rabbit_mq[terraform.workspace].subnets
  key_name                  = local.asg_rabbit_mq[terraform.workspace].ssh_key
  load_balancers            = [ aws_elb.rabbit_lb.name ]

  initial_lifecycle_hooks = []

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  lt_name                = "RabbitMQ-cluster-node"
  description            = "Launch RabbitMQ"
  update_default_version = true


  use_lc    = true
  create_lc = true

  image_id                  = data.aws_ami.rabbitmq-image.id
  instance_type             = "t3.small"
  user_data                 = local.user_data
  ebs_optimized             = true
  enable_monitoring         = true
  iam_instance_profile_name = aws_iam_instance_profile.rabbit_role.name
  security_groups           = local.asg_rabbit_mq[terraform.workspace].security_groups

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp2"
      }
      }
  ]

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  cpu_options = {
    core_count       = 1
    threads_per_core = 1
  }

  credit_specification = {
    cpu_credits = "standard"
  }

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 32
  }

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
    }
  ]

  placement = {
    availability_zone = local.region
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { WhatAmI = "Instance" }
    },
    {
      resource_type = "volume"
      tags          = { WhatAmI = "Volume"}
    }
  ]

  tags = [
    {
      key                 = "Environment"
      value               = terraform.workspace
      propagate_at_launch = true
    },
    {
      key                 = "BillingProject"
      value               = "rabbitmq"
      propagate_at_launch = true
    },
  ]
}

# Create a new load balancer for rabbitMQ cluter
resource "aws_elb" "rabbit_lb" {
  name                = "rabbitmq-elb"
  subnets             = local.rabbitmq_lb[terraform.workspace].subnets
  security_groups     = local.rabbitmq_lb[terraform.workspace].security_groups

  listener {
    instance_port     = 15672
    instance_protocol = "http"
    lb_port           = 15672
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 5672
    instance_protocol = "tcp"
    lb_port           = 5672
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:5672"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name            = "rabbitmq-elb",
    BillingProject  = "rabbitmq"
  }
}