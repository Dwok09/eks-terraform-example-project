resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.environment}_main_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "${var.environment}_public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "${var.environment}_public_subnet"
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
# resource "aws_subnet" "private_subnet" {
#   vpc_id = module.vpc.vpc_id
#   cidr_block = "10.10.20.0/24"
# }
