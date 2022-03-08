module "s3_bucket" {
  source = "./modules/s3"
  bucket = var.bucket

  tags = var.tags
}


module "ecs_fargate" {
  source = "./modules/ecs_fargate"
  prefix = var.prefix
  vpc_id = aws_vpc.vpc.id
  #vpc_id = module.ecs_fargate.vpc_id
  #public_subnet_ids = aws_subnet.subnets_public.id  
  public_subnet_ids = aws_subnet.public.*.id
  private_subnet_ids = aws_subnet.private.*.id
  #private_subnet_ids = aws_subnet.subnets_private.id  
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


/*
module "weather-app" {
  source             = "./modules/fargate-env"
  prefix             = var.prefix
  git_username       = var.git_username
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  image_id           = var.image_id
  app_name           = var.app_name
  container_port     = var.container_port
  task_mem           = var.task_mem
  task_cpu           = var.task_cpu
  desired_count      = var.desired_count
}*/