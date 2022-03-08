
resource "aws_lb_target_group" "lb-tg" {
  name        = "${var.prefix}-wetherapp-lb-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  tags        = {
      Name = "${var.prefix}-lb-tg"
  }
}


resource "aws_lb" "lb" {
  name               = "${var.prefix}-weatherapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [var.public_subnet_ids[0], var.public_subnet_ids[1]]

  tags = {
    Name = "${var.prefix}-alb"
  }
}


resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg.arn
  }
}


output "alb-url" {
  value = aws_lb.lb.dns_name
}
