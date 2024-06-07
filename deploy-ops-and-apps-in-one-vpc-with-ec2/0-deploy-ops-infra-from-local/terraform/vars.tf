variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The name of the project within this VPC"
  type        = string
  # default     = "awesome-project"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.2.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the subnets"
  type        = list(string)
  default     = ["10.2.1.0/24", "10.2.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the subnets"
  type        = list(string)
  default     = ["10.2.4.0/24", "10.2.5.0/24"]
}

variable "key_pair" {
  description = "The ssh key pair for EC2 instances"
  type        = string
  default     = "hackathon"
}

variable "jenkins_name" {
  description = "The name of the Jenkins server"
  type        = string
  default     = "jenkins"
}

// variable for jenkins ami id
variable "jenkins_ami_id" {
  description = "The AMI ID for the Jenkins server"
  type        = string
  default     = "ami-0a2b3971f122ac706"
}

// variable for prometheus ami id
variable "prometheus_ami_id" {
  description = "The AMI ID for the Prometheus server"
  type        = string
  default     = "ami-04b70fa74e45c3917"
}

variable "hosted_zone" {
  description = "The domain name for Route 53 and ACM"
  type        = string
  default     = "fitastic.io"
}
