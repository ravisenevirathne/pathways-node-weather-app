resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.prefix}-vpc"
  }
}


resource "aws_subnet" "private" {
  count = length(var.avail_zone)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnets_private[count.index].cidr
  availability_zone = var.avail_zone[count.index]

  tags = {
    Name = "${var.prefix}-${var.subnets_private[count.index].name}"
  }
}


resource "aws_subnet" "public" {
  count = length(var.avail_zone)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnets_public[count.index].cidr
  availability_zone = var.avail_zone[count.index]

  tags = {
    Name = "${var.prefix}-${var.subnets_public[count.index].name}"
  }
}



resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}


resource "aws_eip" "eip_natgw" {
  count = length(var.subnets_private)

  vpc = true
  tags = {
    "Name" = "${var.prefix}-${var.subnets_private[count.index].name}-eip"
  }
}



resource "aws_nat_gateway" "ngw" {
  count         = length(var.subnets_public)
  allocation_id = aws_eip.eip_natgw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    "Name" = "${var.prefix}-${var.subnets_private[count.index].name}-ngw"
  }


}

resource "aws_route_table" "rt-public" {
  count  = length(var.subnets_public)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
  tags = {
    "Name" = "${var.prefix}-${var.subnets_public[count.index].name}-rt-public"
  }

}

resource "aws_route_table" "rt-private" {
  count  = length(var.subnets_private)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw[count.index].id
  }

depends_on = [
  aws_nat_gateway.ngw
]
  tags = {
    "Name" = "${var.prefix}-${var.subnets_private[count.index].name}-rt-private"
  }

}

resource "aws_route_table_association" "rt-public-association" {
  count          = length(var.subnets_public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt-public[count.index].id
}

resource "aws_route_table_association" "rt-private-association" {
  count          = length(var.subnets_private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rt-private[count.index].id
}

resource "aws_vpc_endpoint" "vpc_endpoint" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  tags = {
    "Name" = "${var.prefix}-s3vpc-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "public_s3_endpoint_association" {
  count = length (var.subnets_public)
  route_table_id = aws_route_table.rt-public[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.vpc_endpoint.id
}

resource "aws_vpc_endpoint_route_table_association" "private_s3_endpoint_association" {
  count = length (var.subnets_private)
  route_table_id = aws_route_table.rt-private[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.vpc_endpoint.id
}


output "vpc_id" {
  value = aws_vpc.vpc.id
}

