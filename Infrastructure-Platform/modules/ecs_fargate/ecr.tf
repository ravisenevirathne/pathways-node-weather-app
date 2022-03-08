
resource "aws_ecr_repository" "ecr-repo" {
  name = "${var.prefix}-node-weather-app"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    "Name" = "${var.prefix}-ecr-repo"
  }
}


output "ecr-repo-url" {
  description = "ECR Repo URL"
  value       = aws_ecr_repository.ecr-repo.repository_url
}