# VPC
# Subnet (Public, Private)
# Route table
# Internet Gateway
# NACL
# NAT Gateway

## Creating VPC for launching the instnace ##
//VPC//
resource "aws_vpc" "demo-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "My_TF_VPC"
  }
}

//Subnets//
resource "aws_subnet" "demo_subnet1" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = "10.0.100.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Public_Subnet"
  }
}
resource "aws_subnet" "demo_subnet2" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.200.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "My_TF_Private_Subnet"
  }
}

//Internet Gateway//
resource "aws_internet_gateway" "demo_IGW" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "My_TF_IGW"
  }
}

# resource "aws_internet_gateway_attachment" "demo_IGW_attachment" {
#   internet_gateway_id = aws_internet_gateway.demo_IGW.id
#   vpc_id              = aws_vpc.demo-vpc.id
# }

//Route Table//
resource "aws_route_table" "demo_RT" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_IGW.id
  }

  tags = {
    Name = "My_TF_RT"
  }
}
resource "aws_route_table_association" "demo_subnet1_RT_association" {
  subnet_id      = aws_subnet.demo_subnet1.id
  route_table_id = aws_route_table.demo_RT.id
}

//Security Group//
resource "aws_security_group" "demo_VPC_SG" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

//ec2 instance//
# resource "aws_instance" "demo-ec2" {
#   ami                    = "ami-09d3b3274b6c5d4aa"
#   instance_type          = "t2.micro"
#   key_name               = "AWS_DevOps_KP"
#   subnet_id              = aws_subnet.demo_subnet1.id
#   vpc_security_group_ids = [aws_security_group.demo_VPC_SG.id]

#   tags = {
#     Name = "My_TF_EC2"
#   }
# }

resource "aws_instance" "demo-ec2_1" {
  ami                    = "ami-09d3b3274b6c5d4aa"
  instance_type          = "t2.micro"
  key_name               = "AWS_DevOps_KP"
  subnet_id              = aws_subnet.demo_subnet1.id
  vpc_security_group_ids = [aws_security_group.demo_VPC_SG.id]

  tags = {
    Name = "Public_EC2"
  }
}
