resource "aws_security_group" "alb-sg" {
  name = "${var.prefix}-alb-sg"
  vpc_id = var.vpc_id

    ingress {
        description = "Allow http traffic"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "default"    
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
       
    }

  tags = {
    Name = "${var.prefix}-alb-sg"
  }

}

resource "aws_security_group" "ecs-sg" {
  name = "${var.prefix}-ecs-sg"
  vpc_id = var.vpc_id

  ingress  {
      description = "Alb to Ecs traffic"
      from_port = var.container_port
      to_port = var.container_port
      protocol = "tcp"
      security_groups = [aws_security_group.alb-sg.id]
  }
      egress {
        description = "default"    
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks  = ["0.0.0.0/0"]

      }
      tags = {
    Name = "${var.prefix}-ecs-sg"
  }

}
