resource "aws_instance" "app" {
  ami                    = "ami-0f918f7e67a3323f0"  
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "project.key"
  iam_instance_profile   = aws_iam_instance_profile.write_profile.name

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
