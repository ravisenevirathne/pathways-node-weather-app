variable "prefix" { type = string }
variable "vpc_id" {}

variable "public_subnet_ids" {

  type        = list(string)
}

variable "private_subnet_ids" {

  type        = list(string)
}
