terraform {
  #required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "pathways-dojo"
    key    = "ravisenevirathne-tfstate-main"
    region = "us-east-1"
  }
}