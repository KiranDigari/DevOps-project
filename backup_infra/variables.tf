variable "aws_region" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "stage" {
  description = "Environment stage like Dev or Prod"
  type        = string
}

variable "repo_url" {
  default = "https://github.com/KiranDigari/DevOps-project.git"
}

variable "shutdown_after_minutes" {
  default = 30
}

variable "bucket_name" {
  description = "Name of the private S3 bucket for log storage"
  type        = string

  validation {
    condition     = length(var.bucket_name) > 0
    error_message = "ERROR: bucket_name must be provided!"
  }
}
