```markdown
# Terraform-AWS-scalable-infrastructure

A Terraform-based, opinionated infrastructure module to provision a scalable, highly available infrastructure on AWS. This repository provides reusable HCL for deploying networking, compute (Auto Scaling Groups / ECS), load balancing, and optional managed services in a way that's suitable for production environments.

## Features

- VPC with public/private subnets and NAT gateways
- Auto Scaling Groups (ASG) or ECS clusters for scalable compute
- Application Load Balancer (ALB) with health checks and target groups
- Optional managed database (RDS) and cache (ElastiCache)
- IAM roles and policies for least-privilege access
- S3-backed remote state support and example CI/CD patterns
- Input variables for environment-specific configuration and tagging

## Requirements

- Terraform >= 1.3 (recommended: latest stable)
- AWS CLI configured with credentials and a default region
- An AWS account with permissions to create networking, EC2, Auto Scaling, IAM, ALB, and (optionally) RDS resources

## Quickstart

1. Clone the repo:

   ```bash
   git clone https://github.com/amankothiyal04/terraform-aws-scalable-infrastructure.git
   cd terraform-aws-scalable-infrastructure
   ```

2. Create a workspace directory for your environment (e.g. `dev`, `staging`, `prod`) and copy or create a `terraform.tfvars` with environment-specific values.

3. Initialize and apply:

   ```bash
   terraform init \
     -backend-config="bucket=your-terraform-state-bucket" \
     -backend-config="key=envs/dev/terraform.tfstate" \
     -backend-config="region=us-east-1"

   terraform plan -var-file="envs/dev/terraform.tfvars"
   terraform apply -var-file="envs/dev/terraform.tfvars"
   ```

   Replace backend config values and var file path with your values.

## Example usage

Top-level usage might look like this in your environment module:

```hcl
module "infra" {
  source = "git::https://github.com/amankothiyal04/terraform-aws-scalable-infrastructure.git?ref=main"

  environment        = "dev"
  region             = "us-east-1"
  vpc_cidr           = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.11.0/24", "10.0.12.0/24"]
  instance_type      = "t3.medium"
  desired_capacity   = 2
  min_size           = 2
  max_size           = 5

  tags = {
    Project     = "my-app"
    Environment = "dev"
  }
}
```

## Recommended variables

(These are common variables used by the module; adapt to your repo's variables if different.)

- environment - name of the target environment (dev/staging/prod)
- region - AWS region to deploy into
- vpc_cidr - CIDR block for the VPC (e.g., 10.0.0.0/16)
- public_subnets - list of public subnet CIDRs
- private_subnets - list of private subnet CIDRs
- instance_type - EC2 instance type used in ASG
- desired_capacity / min_size / max_size - ASG scaling configuration
- enable_rds - (bool) whether to create RDS
- db_instance_class / db_engine / db_name - RDS settings
- tags - map of tags to apply to resources

## Outputs

Typical outputs you can expect:

- vpc_id - ID of the created VPC
- public_subnet_ids - list of public subnet IDs
- private_subnet_ids - list of private subnet IDs
- alb_dns_name - DNS name of the Application Load Balancer
- asg_names - names of Auto Scaling Groups or ECS cluster name
- rds_endpoint - (if created) database endpoint

Use `terraform output` after apply to inspect them.

## Backend & State

This repo assumes you will configure a remote backend (S3 + DynamoDB for locking) in `terraform init` or a `backend.tf`. Example minimal backend config:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

Create the S3 bucket and DynamoDB table prior to initializing Terraform or use a bootstrap process to create them.

## Security & IAM

- The modules create IAM roles and instance profiles. Review generated policies for principle of least privilege before deploying to prod.
- Rotate any long-lived credentials; prefer instance profiles and short-lived OIDC tokens from your CI/CD runner.
- Restrict access to the Terraform state S3 bucket and enable encryption & versioning.

## Testing & Linting

Recommended tools:

- terraform fmt - autoformat code
- terraform validate - validate configuration
- tflint - linting for Terraform best practices
- checkov / tfsec - static analysis and security checks

Examples:

```bash
terraform fmt -recursive
terraform validate
tflint
tfsec .
```

## CI/CD

- Use the `plan` step to run `terraform plan -out=plan.tfplan` and upload the plan artifact for review.
- Apply only from an approved pipeline job with appropriate AWS credentials and backend settings.
- Use workspaces or separate state keys per environment to isolate state.

## Contributing

Contributions are welcome. Please:

1. Open an issue to discuss larger changes.
2. Fork the repo and submit a pull request with tests (where applicable) and documentation updates.
3. Follow the repository's code style (HCL formatting, naming conventions).

## Troubleshooting

- Permission errors: ensure the IAM user/role running Terraform has sufficient permissions (S3, DynamoDB, EC2, RDS, ELB, IAM).
- Provider or module version issues: pin provider versions in `required_providers` and update with care.
- Networking issues: ensure CIDR ranges do not overlap with on-prem or other VPCs if you plan to peer or use VPN/Transit Gateway.
```
