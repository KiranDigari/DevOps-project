# EC2 Deployment & Log Backup — DevOps Projects

This repository automates the deployment of a Java Spring Boot application on AWS EC2 and securely archives system and application logs to a private S3 bucket using IAM roles. All infrastructure is defined using Terraform.

---

## Assignment 1: EC2 App Deployment Automation

This project automates the provisioning of an EC2 instance and the deployment of a Java application.

### Features Covered
- AWS Free Tier used
- EC2 instance creation (type configurable via `tfvars`)
- Install Java 19, Git, Maven using shell script
- Clone and deploy from GitHub repo:  
  [`https://github.com/KiranDigari/DevOps-project`](https://github.com/KiranDigari/DevOps-project)
- Expose app on port 80 (via Security Group)
- Auto-shutdown after a set time (default: 15 mins)
- No hardcoded secrets — uses `aws configure` or ENV variables
- Supports stage parameter (`dev`, `prod`) via `tfvars`
- Parameters like `instance_type`, `repo_url`, and `shutdown_after_minutes` are configurable

---

## Assignment 2: EC2 + App Logs Backup to Private S3

Extends Assignment 1 by backing up logs to a private S3 bucket using IAM roles.

### Features Covered
- Created 2 IAM Roles:
  - **Read-only Role** (can list S3 objects only)
  - **Write-only Role** (can upload to S3 but cannot read/download)
- Attached write-only role to EC2 instance via `aws_iam_instance_profile`
- Created private S3 bucket (`bucket_name` is configurable)
- Uploaded logs to S3:
  - EC2 logs: `/var/log/cloud-init.log` → `s3://<bucket>/ec2-logs/`
  - App logs: `/opt/app/logs/*.log` → `s3://<bucket>/app/logs/`
- Lifecycle rule to auto-delete logs after 7 days
- Launched separate EC2 instance with read-only role to verify access (list-only)

---

## How to Use

```bash
cd infra/
terraform init
terraform apply -var="stage=dev" -var="bucket_name=your-bucket-name"


