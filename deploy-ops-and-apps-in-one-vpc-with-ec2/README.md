# Deploy Ops and Apps in One VPC with EC2

This folder provides resources to deploy both operations tools and applications within a single Virtual Private Cloud (VPC) on EC2 instances. The aim is to integrate key DevOps tools like Jenkins, Prometheus, and Grafana, along with applications, to ensure a cohesive and manageable infrastructure suitable for small-sized projects.

## Purpose

The goal is to streamline the deployment process by integrating essential operations tools and applications within the same VPC. This setup ensures efficient resource utilization, simplified network management, and enhanced security by keeping all components within a single, isolated environment.

## Tools and Technologies

This project includes configurations and templates for deploying the following tools and technologies on EC2 instances:

- **CI/CD with Jenkins**: Automate your build, test, and deployment processes using Jenkins.
- **Monitoring with Prometheus**: Collect and analyze metrics to monitor the performance and health of your applications and infrastructure.
- **Visualization with Grafana**: Visualize metrics and logs for better insight and analysis using Grafana dashboards.
- **Application Deployment**: Deploy applications on EC2 instances within the same VPC.

## Project Structure

The folder is organized into several subdirectories and files to help set up the infrastructure and deploy the tools and applications:

- **terraform/**: Contains Terraform scripts to provision the necessary AWS infrastructure, including VPC, subnets, security groups, and EC2 instances.
- **jenkins/**: Configuration files and setup scripts for deploying Jenkins on EC2.
- **prometheus/**: Configuration files and setup scripts for deploying Prometheus on EC2.
- **grafana/**: Configuration files and setup scripts for deploying Grafana on EC2.
- **applications/**: Example configurations and deployment scripts for deploying applications on EC2 instances.

## Project Structure

The folder is organized into several subdirectories and files to help set up the infrastructure and deploy the tools and applications:

- **initial-setup/**: Contains Terraform scripts to provision the initial AWS infrastructure, including VPC, subnets, security groups, and EC2 instances.
- **jenkins-provision/**: Contains Terraform scripts managed by Jenkins to provision infrastructure for running the application in Docker.
- **docker-image-update/**: Contains Jenkins pipelines and scripts to update the Docker images for the application.
- **packer-ansible/**: Contains Packer and Ansible scripts to generate the golden image of the AMI with Docker installed.

## Provision and CI/CD Flow

1. **Initial Provisioning**: 
   - Navigate to the `initial-setup/` directory and run the Terraform script locally to set up the initial AWS infrastructure and deploy the ops tools like Jenkins, Prometheus, and Grafana.

   ```bash
   cd initial-setup
   terraform init
   terraform apply
   ```
