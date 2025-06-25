# 🚀 EC2 Deployment Automation — DevOps Project 1

This project automates the deployment of a Java Spring Boot application on AWS EC2 using Terraform and a shell script.

---

## ✅ Assignment Requirements Covered

1. ✅ Sign up for AWS Free Tier and use it
2. ✅ Spin up EC2 instance (configurable type via tfvars)
3. ✅ Install Java 19
4. ✅ Clone GitHub repo & deploy app  
   - Repo: [https://github.com/KiranDigari/DevOps-project](https://github.com/KiranDigari/DevOps-project)
5. ✅ Make app accessible on **port 80**
6. ✅ Auto-shutdown EC2 instance after a set time (default: 15 mins)
7. ✅ No secrets or access keys added in repo (uses `aws configure` / ENV)
8. ✅ Supports **Stage** parameter like `dev` or `prod`  
   - Config picked accordingly (`dev.tfvars`, `prod.tfvars`)
9. ✅ All key parameters like instance type, repo URL, dependencies are configurable

---

## 🛠 Project Structure

