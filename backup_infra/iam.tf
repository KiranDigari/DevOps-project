data "aws_iam_policy_document" "ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# 🔹 S3 Read-Only Role
resource "aws_iam_role" "s3_read_role" {
  name               = "s3-read-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

resource "aws_iam_policy" "s3_read_policy" {
  name   = "s3-read-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:ListBucket", "s3:GetObject"],
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "read_attach" {
  role       = aws_iam_role.s3_read_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

# 🔸 S3 Write-Only Role
resource "aws_iam_role" "s3_write_role" {
  name               = "s3-write-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

resource "aws_iam_policy" "s3_write_policy" {
  name   = "s3-write-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:PutObject", "s3:CreateBucket"],
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "write_attach" {
  role       = aws_iam_role.s3_write_role.name
  policy_arn = aws_iam_policy.s3_write_policy.arn
}

# 🔗 Instance Profile to attach Write Role to EC2
resource "aws_iam_instance_profile" "write_profile" {
  name = "ec2-write-profile"
  role = aws_iam_role.s3_write_role.name
}
