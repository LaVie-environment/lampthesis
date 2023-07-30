    variable "region" {
        default = "eu-west-2"
    }

    variable "instance_type" {
        default = "t2.micro"
    }

    variable "profile_name" {
        default = "gachio"
    }

    variable "vpc_cidr" {
        default = "178.0.0.0/16"
    }

    variable "uat_public_subnet_cidr" {
        default = "178.0.10.0/24"
    }