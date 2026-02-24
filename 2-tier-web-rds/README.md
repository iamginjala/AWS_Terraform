# 2-Tier Web Application with RDS — Terraform

A two-tier web application deployed on AWS using Terraform modules. A Flask web server on EC2 (public tier) connects to a MySQL database on RDS (private tier) inside a custom VPC.

---

## Architecture

```
Internet
    │
    ▼
[ web_sg: 80/443/22 ]
    │
    ▼
[ EC2 - Ubuntu - Flask App ]   ← Public Subnet (us-east-2a)
    │
    │  port 3306
    ▼
[ db_sg: 3306 from web_sg only ]
    │
    ▼
[ RDS - MySQL 8.0 ]            ← Private Subnets (us-east-2a + us-east-2b)
```

---

## Modules

| Module | Description |
|---|---|
| `vpc` | VPC, public subnet, 2 private subnets across 2 AZs, IGW, route tables |
| `security_groups` | Web SG (HTTP/HTTPS/SSH) and DB SG (MySQL from web only) |
| `secrets` | Generates a random password and stores credentials in AWS Secrets Manager |
| `rds` | DB subnet group and MySQL RDS instance in private subnets |
| `ec2` | Ubuntu EC2 in public subnet, bootstrapped with Flask app via user_data |

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- AWS CLI configured with appropriate credentials
- AWS account with permissions for VPC, EC2, RDS, and Secrets Manager

---

## Usage

```bash
# Initialise Terraform
terraform init

# Preview changes
terraform plan

# Deploy
terraform apply

# Destroy all resources
terraform destroy
```

---

## Variables

| Variable | Description | Default |
|---|---|---|
| `project_name` | Name used for tagging all resources | `day22-rds-demo` |
| `environment` | Environment name (dev/staging/prod) | `dev` |
| `aws_region` | AWS region to deploy into | `us-east-2` |
| `vpc_cidr` | CIDR block for the VPC | `10.0.0.0/16` |
| `public_subnet_cidr` | CIDR for the public subnet | `10.0.1.0/24` |
| `private_subnet_cidrs` | CIDRs for the two private subnets | `["10.0.2.0/24", "10.0.3.0/24"]` |
| `ec2_instance_type` | EC2 instance size | `t2.micro` |
| `db_name` | Name of the MySQL database | `webappdb` |
| `db_username` | Master database username | `admin` |
| `db_instance_class` | RDS instance size | `db.t3.micro` |
| `db_allocated_storage` | Storage allocated to RDS in GB | `10` |
| `db_engine_version` | MySQL engine version | `8.0` |

---

## Outputs

| Output | Description |
|---|---|
| `vpc_id` | ID of the created VPC |
| `web_server_public_ip` | Public IP of the EC2 instance |
| `web_server_public_dns` | Public DNS of the EC2 instance |
| `application_url` | URL to access the Flask application |
| `rds_endpoint` | Hostname of the RDS instance |
| `rds_port` | Port of the RDS instance |
| `database_name` | Name of the created database |

---

## Security Notes

- RDS is in private subnets with no internet access
- DB security group only accepts traffic from the web security group on port 3306
- Database password is randomly generated and stored in AWS Secrets Manager
- SSH (port 22) is open to `0.0.0.0/0` — restrict to your IP in production

---

## Project Structure

```
2-tier-web-rds/
├── main.tf                   # Root module — wires all modules together
├── variables.tf              # Root-level variable declarations
├── outputs.tf                # Root-level outputs
├── provider.tf               # AWS provider configuration
├── backend.tf                # Terraform state backend configuration
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security_groups/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── secrets/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── rds/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ec2/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── templates/
            └── user_data.sh
```
