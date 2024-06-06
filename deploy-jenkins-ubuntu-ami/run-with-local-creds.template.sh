#!/bin/bash

export AWS_ACCESS_KEY_ID="<aws access key id>"
export AWS_SECRET_ACCESS_KEY="<aws secret key>"
export AWS_DEFAULT_REGION="<aws region>"
packer build jenkins-ubuntu-ami.pkr.hcl