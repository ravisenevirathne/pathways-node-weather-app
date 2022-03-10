module "s3_bucket" {
  source = "./modules/s3"
  bucket = var.bucket

  tags = var.tags
}


module "ecs_fargate" {
  source = "./modules/ecs_fargate"
  prefix = var.prefix
  vpc_id = aws_vpc.vpc.id
  public_subnet_ids = aws_subnet.public.*.id
  private_subnet_ids = aws_subnet.private.*.id
  fargate_count = var.fargate_count
  fargate_cpu = var.fargate_cpu
  fargate_memory = var.fargate_memory
  container_port = var.container_port
  
}



output "bucket_name" {
  description = "The name of the bucket"
  value       = ["${module.s3_bucket.s3_bucket_name}"]
}

output "bucket_name_arn" {
  description = "The name of the bucket"
  value       = ["${module.s3_bucket.s3_bucket_name_arn}"]
}

output "ecr-repo-url" {
  description = "ECR Repo URL"
  value = ["${module.ecs_fargate.ecr-repo-url}"]
}

output "alb-url" {
  description = "ALB DNS Name"
  value = ["${module.ecs_fargate.alb-url}"]
}

