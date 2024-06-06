# Packer AWS AMI with Docker

This project contains the necessary configuration and scripts to build an AWS AMI with Docker installed using Packer.

## Running Packer

There are two ways to run Packer for this project:

1. **Run Packer Locally**
2. **Run Packer from an EC2 Instance with an IAM Role**

### 1. Run Packer Locally

To run Packer locally, you need to provide AWS credentials. Create a `run-with-local-creds.sh` script from the template by replacing the placeholders with your actual AWS credentials.

### 2. Run Packer from an EC2 Instance with an IAM Role

To run Packer from an EC2 instance, ensure that the instance has an appropriate IAM role attached. The required role policy is provided in `packer-deployer-role-policy.json`. Then, execute `run-with-packer-deployer-role.sh`.

