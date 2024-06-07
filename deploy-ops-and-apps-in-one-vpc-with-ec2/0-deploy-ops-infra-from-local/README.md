# Project Specific VPC Deployment

This project contains the necessary configuration and scripts to deploy a VPC with the following resources using Terraform and custom AMIs built with Packer:

- Jenkins on its own EC2 instance
- Prometheus and Grafana on a shared EC2 instance
- Application EC2 instance with Docker installed
- Public bastion host for SSH access
- Application Load Balancer to expose Jenkins, Prometheus, Grafana, and the application

## Getting Started

### 1 Create .env

Duplicate `template.env` and rename it to `.env`.

Modify the access key id and secret access key.

### 2 Supply additional Terraform variables

The followings are the variables to customise:
1. aws_region
2. project_name
3. vpc_cidr
4. public_subnet_cidrs
5. private_subnet_cidrs
6. key_pair
7. jenkins_name
8. jenkins_ami_id
9. prometheus_ami_id
10. hosted_zone

Set the default values in `vars.tf`.

### 3 Run deployment script

```
bash deploy-tf.sh
```