# Policy to 
resource "aws_iam_policy" "rabbit_mq_cluster_policy" {
  name        = "rabbitMQ-cluster-policy"
  path        = "/"
  description = "Policy to Allow new rabbitMQ intances to join in the RabbitMQ cluster"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "autoscaling:DescribeAutoScalingGroups",
              "autoscaling:DescribeAutoScalingInstances",
              "ec2:DescribeInstances"
          ],
          "Resource": [
              "*"
          ]
      }
    ]
  })

  tags = {}
}