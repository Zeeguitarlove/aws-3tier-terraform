# AWS 3-Tier Architecture (Terraform)

This project sets up a basic 3-tier AWS architecture using Terraform. It uses a modular approach for better organization and reuse. The setup includes:

- **VPC** with public and private subnets
- **Internet Gateway** for public access
- **NAT Gateway** for private subnet egress
- **Route Tables** for each subnet type
- **EC2 Instances** in both public and private subnets

---

# Project Structure

aws-3tier-project/
├── main.tf
├── terraform.tfvars
├── modules/
│ └── network/
│ ├── main.tf
│ └── variables.tf

---

### How to Use

### 1. Clone the Repo

git clone https://github.com/your-username/aws-3tier-terraform.git
cd aws-3tier-terraform

### 2. Create Your terraform.tfvars

Create a terraform.tfvars file in the root with your values:

region              = "us-east-1"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
key_name            = "your-existing-ec2-keypair"

### Do not commit your .tfvars file.

3. Initialize & Apply

terraform init

terraform plan

terraform apply

### Security & Best Practices

.gitignore is set up to avoid pushing sensitive files (.pem, .tfstate, etc.)

Key Pair must exist before running terraform apply.

Avoid Hardcoding values — use variables and tfvars.

Tag Resources (future improvement)

###  Architecture Overview
### A typical 3-tier setup:

[ Internet ]
     |
     [Public Subnet] ----> EC2 (Bastion/Nginx/etc)
          |
          [NAT Gateway]
               |
               [Private Subnet] ----> EC2 (App/DB)

               Terraform version used: >= 1.5.0

               AWS Provider: ~> 5.0

               Resources can be expanded to add RDS, ALB, Auto Scaling, etc.
