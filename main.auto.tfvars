vpc_cidr = "10.0.1.0/24"

prefix = "RaviS"

tags = {
  "name" = "Ravi Senevirathne"
  "Project" = "Pathways Dojo Weather App"
}

avail_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]

subnets_public = [
  {name = "public-a",cidr = "10.0.1.16/28"},
  {name = "public-b",cidr = "10.0.1.32/28"},
  {name = "public-c",cidr = "10.0.1.48/28"}]

subnets_private = [
  {name = "private-a",cidr = "10.0.1.64/26"},
  {name = "private-b",cidr = "10.0.1.128/26"},
  {name = "private-c",cidr = "10.0.1.192/26"}]
