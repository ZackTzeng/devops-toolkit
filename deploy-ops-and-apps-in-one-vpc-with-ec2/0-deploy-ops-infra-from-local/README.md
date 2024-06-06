# Project Specific VPC Deployment

This project contains the necessary configuration and scripts to deploy a VPC with the following resources using Terraform and custom AMIs built with Packer:

- Jenkins on its own EC2 instance
- Prometheus and Grafana on a shared EC2 instance
- Application EC2 instance with Docker installed
- Public bastion host for SSH access
- Application Load Balancer to expose Jenkins, Prometheus, Grafana, and the application

## Infrastructure Overview

- **VPC**: A dedicated Virtual Private Cloud for this project.
- **Subnets**: Public and private subnets within the VPC.
- **Security Groups**: To control access to the instances.
- **Custom AMIs**: Built using Packer, these AMIs include Docker installed.
- **Application Load Balancer (ALB)**: Exposes Jenkins, Prometheus, Grafana, and the application.

## Getting Started

### 1 Replace project-name in vars.tf with the actual project name