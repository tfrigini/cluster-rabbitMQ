module "rabbitmq-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "RabbitMQ-sg"
  description = "Security group for RabbitMQ"
  vpc_id      = module.vpc.vpc_id
  create      = true

  ingress_with_self = [
    {
      rule = "all-all"
    },{
      from_port   = 4369
      to_port     = 4369
      protocol    = 6
      description = "epmd peer discovery service used by RabbitMQ"
    },
    {
      from_port   = 5672
      to_port     = 5672
      protocol    = 6
      description = "AMQP 0-9-1 and 1.0 clients without and with TLS"
    },
    {
      from_port   = 15672
      to_port     = 15672
      protocol    = 6
      description = "HTTP API clients and rabbitmqadmin"
    }
  ]
  
}