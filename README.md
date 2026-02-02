# AWS Terraform Practice

This repository contains Terraform configurations for learning and practicing AWS infrastructure as code.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) installed
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- An AWS account

## Learning Roadmap

### Fundamentals
- [ ] Terraform basics (providers, resources, variables, outputs)
- [ ] State management
- [ ] Terraform CLI commands

### AWS Services
- [ ] IAM (Users, Roles, Policies)
- [ ] EC2 (Instances, Security Groups, Key Pairs)
- [ ] VPC (Subnets, Route Tables, Internet Gateway)
- [ ] S3 (Buckets, Policies, Lifecycle Rules)
- [ ] RDS (Database Instances)
- [ ] Lambda (Functions, API Gateway)

### Advanced Topics
- [ ] Modules
- [ ] Remote state with S3 backend
- [ ] Workspaces
- [ ] Terraform Cloud
- [ ] LifeCycle Rulea

## Project Structure

```
.
├── modules/          # Reusable Terraform modules
├── environments/     # Environment-specific configurations
│   ├── dev/
│   └── prod/
└── projects/         # Individual practice projects
```

## Usage

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply

# Destroy resources
terraform destroy
```

## Resources

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
