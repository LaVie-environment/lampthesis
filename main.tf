terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
    region = var.region
    profile = var.profile_name
}

# Create a VPC
resource "aws_vpc" "uat_vpc" {
  cidr_block  = "178.0.0.0/16"

  tags = {
    Name = "uat-vpc"
  }
}

resource "aws_internet_gateway" "uat_gw" {
  vpc_id = aws_vpc.uat_vpc.id

  tags = {
    Name = "uat_igw"
  }
}

resource "aws_subnet" "uat_public_subnet" {
  vpc_id     = aws_vpc.uat_vpc.id
  cidr_block = var.uat_public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = "eu-west-2a"

  tags = {
    Name = "uat-public_subnet"
  }
}

resource "aws_route_table" "uat_public_rt" {
  vpc_id = aws_vpc.uat_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.uat_gw.id
  }

  tags = {
    Name = "uat-public_rt"
  }
}

resource "aws_route_table_association" "uat_public_rt_asso" {
  subnet_id      = aws_subnet.uat_public_subnet.id
  route_table_id = aws_route_table.uat_public_rt.id
}

resource "aws_instance" "uat_env" {
    ami = "ami-0eb260c4d5475b901"
    instance_type = var.instance_type
    subnet_id = aws_subnet.uat_public_subnet.id
    security_groups = [aws_security_group.uat_sg.id]

    user_data = <<-EOF
    #!/bin/bash
    echo "*** Installing Nginx"
    sudo apt update -y
    sudo apt install nginx -y
    echo "*** Completed Installing Nginx"
    EOF

    tags = {
        Name = "terraform-uat_env"
    }
}


terraform {
  backend "s3" {
    bucket = "works-up-and-running-state"
    key = "global/s3/terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "works-up-and-running-state"
    encrypt = true
  }
}



