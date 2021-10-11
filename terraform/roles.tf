resource "aws_iam_role" "rabbitMQ_role" {
  name = "rabbitmq-cluster-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })

  tags = {}
}

resource "aws_iam_role_policy_attachment" "attach_rabbit_policy_to_rabbit_role" {
  role       = aws_iam_role.rabbitMQ_role.name
  policy_arn = aws_iam_policy.rabbit_mq_cluster_policy.arn
}