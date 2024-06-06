provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.project_name
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway      = true
  enable_vpn_gateway      = false
  single_nat_gateway      = true
  one_nat_gateway_per_az  = false
  map_public_ip_on_launch = true

  # tags = {
  #   Terraform = "true"
  #   Environment = "dev"
  # }
}
