variable "prefix" { type = string }
variable "vpc_id" {}

variable "public_subnet_ids" { type = list(string)}

variable "private_subnet_ids" { type = list(string)}
variable "fargate_cpu" {
  type = number
}

variable "fargate_memory" {
  type = number
}

variable "fargate_count" {
  type = number
}

variable "container_port" {
  type = number
}

