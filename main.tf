terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = "eu-west-2"
    profile = "gachio"
}

resource "aws_instance" "uat_env" {
    ami = "ami-0eb260c4d5475b901"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.uat_group.id]

    user_data = <<-EOF
                #!/bin/bash
                sudo apt-get install httpd
                echo "<p> My Instance! </p>" >> /var/www/html/index.html
                sudo systemctl enable httpd
                sudo systemctl start httpd
                EOF

    tags = {
        Name = "terraform-uat_env"
    }
}


resource "aws_security_group" "uat_group" {
  name        = "uat_env_group"
  description = "Allow TLS inbound traffic"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


