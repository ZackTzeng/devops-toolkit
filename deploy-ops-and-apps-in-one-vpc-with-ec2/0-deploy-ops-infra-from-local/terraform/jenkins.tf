resource "aws_iam_role" "jenkins_instance_role" {
  name = "${var.project_name}-${var.jenkins_name}-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "terraform_deployer_role_policy" {
  name        = "${var.project_name}-${var.jenkins_name}-TerraformDeployerRolePolicy"
  description = "Policy to allow Jenkins EC2 instance to deploy infrastructure using Terraform"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:*",
          "iam:*",
          "s3:*",
          "rds:*",
          "dynamodb:*",
          "lambda:*",
          "cloudformation:*",
          "logs:*",
          "cloudwatch:*",
          "autoscaling:*",
          "elasticloadbalancing:*",
          "eks:*",
          "kms:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "packer_deployer_role_policy" {
  name        = "${var.project_name}-${var.jenkins_name}-PackerDeployerRolePolicy"
  description = "Policy to allow Jenkins EC2 instance to deploy infrastructure using Packer"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeRegions",
          "ec2:DescribeImages",
          "ec2:CreateImage",
          "ec2:RunInstances",
          "ec2:CreateTags",
          "ec2:TerminateInstances",
          "ec2:StopInstances",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstanceAttribute",
          "ec2:DescribeSecurityGroups",
          "ec2:CreateSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:DescribeKeyPairs",
          "iam:PassRole"
        ],
        Resource = "*"
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "jenkins_instance_role_terraform_deployer_role_policy_attachment" {
  role       = aws_iam_role.jenkins_instance_role.name
  policy_arn = aws_iam_policy.terraform_deployer_role_policy.arn
}

// attachment for packer deployer role policy
resource "aws_iam_role_policy_attachment" "jenkins_instance_role_packer_deployer_role_policy_attachment" {
  role       = aws_iam_role.jenkins_instance_role.name
  policy_arn = aws_iam_policy.packer_deployer_role_policy.arn
}

resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "${var.project_name}-${var.jenkins_name}-instance-profile"
  role = aws_iam_role.jenkins_instance_role.name
}

# EC2 Instance
resource "aws_instance" "jenkins" {
  ami           = var.jenkins_ami_id
  instance_type = "c5.xlarge"
  # subnet_id     = element(module.vpc.private_subnets, 0)
  subnet_id     = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [
    aws_security_group.private_all.id,
    aws_security_group.public_jenkins_web.id
  ]
  key_name             = var.key_pair
  iam_instance_profile = aws_iam_instance_profile.jenkins_instance_profile.name

  tags = {
    Name = "${var.project_name}-${var.jenkins_name}"
  }
}

# Target Group
resource "aws_lb_target_group" "jenkins_tg" {
  name     = "${var.project_name}-${var.jenkins_name}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/login"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Register EC2 instance with Target Group
resource "aws_lb_target_group_attachment" "jenkins_attachment" {
  target_group_arn = aws_lb_target_group.jenkins_tg.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}

# Route 53
data "aws_route53_zone" "jenkins_selected" {
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.jenkins_selected.zone_id
  name    = "${var.project_name}-${var.jenkins_name}.${var.hosted_zone}"
  type    = "A"

  alias {
    name                   = aws_lb.jenkins_alb.dns_name
    zone_id                = aws_lb.jenkins_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "jenkins_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.jenkins_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.jenkins_selected.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.value]
}

# ACM Certificate
resource "aws_acm_certificate" "jenkins_cert" {
  domain_name       = "${var.project_name}-${var.jenkins_name}.${var.hosted_zone}"
  
  validation_method = "DNS"

  tags = {
    Name = "${var.project_name}-${var.jenkins_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "jenkins_cert_validation" {
  certificate_arn         = aws_acm_certificate.jenkins_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.jenkins_cert_validation : record.fqdn]
}