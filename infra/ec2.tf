resource "aws_security_group" "web_sg" {
  name = "web-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

resource "aws_instance" "app" {
  ami                    = "ami-0f918f7e67a3323f0"  
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "project.key" 
  user_data              = templatefile("${path.module}/../scripts/setup.sh", {
    repo_url               = var.repo_url,
    shutdown_after_minutes = var.shutdown_after_minutes
  })

  tags = {
    Name  = "App-${var.stage}"
    Stage = var.stage
  }
}
