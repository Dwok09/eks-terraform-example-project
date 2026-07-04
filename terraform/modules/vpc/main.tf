resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.environment}_main_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = "${var.environment}_public_subnet",
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "${var.environment}_private_subnet",
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_internet_gateway" "main_int_gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.environment}_main_int_gw"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}_nat_eip"
  }
}

resource "aws_nat_gateway" "public_nat_gw" {
  subnet_id  = aws_subnet.public_subnet.id
  depends_on = [aws_internet_gateway.main_int_gw]
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = "${var.environment}_public_nat_gw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_int_gw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block =  "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_nat_gw.id
  }

  tags = {
    Name = "private_route_table"
  }
}
