resource "aws_vpc" "vpc" {
  cidr_block       = "10.20.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "DEV-VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "DEV_IGW"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.20.1.0/24"

  tags = {
    Name = "DEV-SUBNET"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "DEV-RT"
  }
}

resource "aws_route_table_association" "rt-association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route-table.id
}

resource "aws_security_group" "dev-sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DEV-SG-terraform"
  }
}

