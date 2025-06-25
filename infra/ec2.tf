data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "web-sg"
    Stage = var.stage
  }
}
resource "aws_instance" "app" {
  ami                         = "ami-0f918f7e67a3323f0"  # Make sure this AMI is valid for ap-south-1
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = "project.key"  # Ensure this key exists in your AWS region
  iam_instance_profile        = aws_iam_instance_profile.write_profile.name

  user_data = templatefile("${path.module}/../scripts/setup.sh", {
    repo_url               = var.repo_url,
    shutdown_after_minutes = var.shutdown_after_minutes,
    bucket_name            = var.bucket_name
  })

  tags = {
    Name  = "App-${var.stage}"
    Stage = var.stage
  }
}

resource "aws_instance" "s3_read_tester" {
  ami                         = "ami-0f918f7e67a3323f0"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = "project.key"
  iam_instance_profile        = aws_iam_instance_profile.read_profile.name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install unzip curl -y
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install
              EOF

  tags = {
    Name  = "S3-Read-Tester-${var.stage}"
    Stage = var.stage
  }
}
