#Provider
provider "aws" {
  region = var.region
}
 
# VPC and Networking
resource "aws_vpc" "demo-vpc-uc8" {
cidr_block = var.vpc_cidr
  tags = {
    Name = "demo-vpc-uc8"
  }
}

#Creation Internet Gateway
resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.demo-vpc-uc8.id
  tags = {
    Name = "demo-vpc-uc8-igw"
  }
}

#Create EIP
resource "aws_eip" "eip" {
  tags = {
    Name = "demo-vpc-uc8-eip"
  }
}

#Create Nat gateway
resource "aws_nat_gateway" "demo-natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "demo-vpc-uc2-nat-gw"
  }
}

#Creation Public Subnet
resource "aws_subnet" "public_subnet" {
  count             = 2
  vpc_id = aws_vpc.demo-vpc-uc8.id
  cidr_block        = element(var.public_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

#Creation Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = 2
  vpc_id = aws_vpc.demo-vpc-uc8.id
  cidr_block        = element(var.private_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

#Assigning Internet to Internet Gateway in Routes
resource "aws_route_table" "public_routes" {
vpc_id = aws_vpc.demo-vpc-uc8.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#Assigning Internet to Nat Gateway in Routes
resource "aws_route_table" "private_routes" {
vpc_id = aws_vpc.demo-vpc-uc8.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.demo-natgw.id
  }
}

#Adding Public subnets in Subnet Association
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_routes.id
}

#Adding Private subnets in Subnet Association
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_routes.id
}

# Creating Security Group from ALB 
resource "aws_security_group" "alb" {
  name   = "alb-sg"
vpc_id = aws_vpc.demo-vpc-uc8.id
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#Creating Security Group for ECS Farget
resource "aws_security_group" "ecs_farget" {
  name   = "ecs-farget"
  vpc_id = aws_vpc.demo-vpc-uc8.id
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}