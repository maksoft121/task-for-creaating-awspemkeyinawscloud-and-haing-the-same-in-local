# Create VPC
resource "aws_vpc" "testvpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "test-VPC"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "testgateway" {
  vpc_id = aws_vpc.testvpc.id

  tags = {
    Name = "test-igw"
  }
}

# Creating Route Table
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.testvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testgateway.id
  }

  tags = {
    Name = "Route-table1"
  }
}
resource "tls_private_key" "rsa" {
  algorithm     = "RSA"
  rsa_bits      = 4096
}

resource "aws_key_pair" "mak1" {
  key_name      = "my-key1"
  public_key    = tls_private_key.rsa.public_key_openssh
}
resource "local_file" "mak-key1" {
    content = tls_private_key.rsa.private_key_pem
    filename= "my-key1.pem"
  }

# Creating 1st web subnet
resource "aws_subnet" "subnet-1" {
  vpc_id                  = aws_vpc.testvpc.id
  cidr_block              = var.subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone        = "us-east-1a"

  tags = {
    Name = "Subnet 1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id                  = aws_vpc.testvpc.id
  cidr_block              = var.subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone        = "us-east-1b"

  tags = {
    Name = "Subnet 2"
  }
}

# Associating Route Table
resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.route.id
}

# Creating Security Group
resource "aws_security_group" "terra1-sg" {
  vpc_id = aws_vpc.testvpc.id

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Linux and install Docker
resource "aws_instance" "linux" {
  ami                         = "ami-08a0d1e16fc3f61ea"
  instance_type               = "t2.micro"
  key_name                    = "my-key1"
  subnet_id                   = aws_subnet.subnet-1.id
  vpc_security_group_ids      = [aws_security_group.terra1-sg.id]
  associate_public_ip_address = true  # Enable auto-assigning public IP
  user_data = <<-EOF
               #!/bin/bash
               sudo yum -y update
               sudo yum install docker -y
               sudo systemctl start docker
               sudo systemctl enable docker
               sudo docker pull maksoft121/makfirstimagenginx:challange
               sudo docker container run -itd -p 80:80 maksoft121/makfirstimagenginx:challange
               EOF
}