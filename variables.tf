variable "bucket" {
  type        = string
  description = "Specifies the name of an S3 Bucket"
  default     = "ravisenevirathne-weather-app-bucket"
}

variable "tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default     = {}
}

variable "prefix" {
  type = string
}
variable "vpc_cidr" {
  type = string
}

variable "avail_zone" {
  type = list(string)
}

variable "subnets_public" {
  description = "Public Subnets"
  type = list(object({
    name = string
    cidr = string
  }))
}

variable "subnets_private" {
  description = "Private Subnets"
  type = list(object({
    name = string
    cidr = string
  }))
}

