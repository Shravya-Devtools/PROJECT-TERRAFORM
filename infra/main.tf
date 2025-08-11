# S3 bucket for Terraform state (must match backend.tf bucket name)
resource "aws_s3_bucket" "state_backend" {
  bucket = "your-terraform-state-bucket"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# DynamoDB table for state lock
resource "aws_dynamodb_table" "state_lock" {
  name         = "state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Example EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-04e08e36e17a21b56"   # Replace with your region's AMI
  instance_type = "t2.micro"

  tags = {
    Name = "MyTerraformInstance"
  }
}

# (Optional) Add Lambda, ECS, etc. here as needed
