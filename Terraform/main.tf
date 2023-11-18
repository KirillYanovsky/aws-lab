provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
}

# VPC Module

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name               = "Lab-vpc"
  cidr               = "10.0.0.0/16"
  azs                = data.aws_availability_zones.available.names
  private_subnets    = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.2.0/24", "10.0.4.0/24"]
  enable_nat_gateway = true

  tags = {
    Name      = "Lab-vpc"
    Terraform = "true"
  }
}

resource "aws_security_group" "allow_internal" {
  name        = "sg_allow_vpc_internal"
  description = "Allow VPC Internal Traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "access within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    description = "ssh access"
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
    Terraform = "true"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "sg_allow_http"
  description = "Allow http Traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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
    Terraform = "true"
  }
}
