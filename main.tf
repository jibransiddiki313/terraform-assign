terraform {
        required_providers {
        aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
        }
        }
}         
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1" 
}

resource "aws_security_group" "my_sg" {
  name        = "my_security_group"
  description = "Allow inbound traffic on port 80"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance1" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "MyInstance1"
  }
}

resource "aws_instance" "my_instance2" {
  ami           = "ami-007855ac798b5175e"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "MyInstance2"
  }
}

# Create a load balancer
resource "aws_elb" "my_elb" {
  name               = "my_load_balancer"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = [aws_subnet.my_subnet.id]
  instances          = [aws_instance.my_instance1.id, aws_instance.my_instance2.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
