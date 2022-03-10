resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.prefix}-weatherapp-ecs-cluster"
    setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


resource "aws_ecs_task_definition" "ecs-task" {
    family = "${var.prefix}-ecs-task-family"
    network_mode = "awsvpc"
    execution_role_arn = aws_iam_role.ecs-role.arn
    task_role_arn = aws_iam_role.ecs-role.arn
    memory = var.fargate_memory
    cpu = var.fargate_cpu
    requires_compatibilities = ["FARGATE"]
    container_definitions = jsonencode(
[
{
    "portMappings": [
    {
        "protocol": "tcp",
        "containerPort": "${var.container_port}"
    }],
    "name": "ravis-weatherapp",
    "image": "152848913167.dkr.ecr.us-east-1.amazonaws.com/ravis-node-weather-app:1",

}
]
  )
}


resource "aws_ecs_service" "ecs-service" {
  name =    "${var.prefix}-weatherapp-ecs-service"
  cluster   = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.ecs-task.arn
  desired_count = var.fargate_count
  #platform_version = "1.3.0"
  launch_type = "FARGATE"
  depends_on = [aws_iam_role.ecs-role, aws_iam_policy.ecs-policy, aws_iam_role_policy_attachment.ecs-attachment]

  network_configuration {
    security_groups = [aws_security_group.ecs-sg.id]
    subnets = [var.private_subnet_ids[0], var.private_subnet_ids[1]]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb-tg.arn
    container_name = "ravis-weatherapp"
    container_port = var.container_port
  }

  
}
