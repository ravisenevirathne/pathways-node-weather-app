resource "aws_iam_policy" "ecs-policy" {
  name        = "${var.prefix}-EcsEcrAccess"
  path        = "/"
  description = "ecs policy to pull the uploaded image"
policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_role" "ecs-role" {
    name = "${var.prefix}-EcsExecutionRole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "ecs-tasks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs-attachment" {
  role = aws_iam_role.ecs-role.name
  policy_arn = aws_iam_policy.ecs-policy.arn
}