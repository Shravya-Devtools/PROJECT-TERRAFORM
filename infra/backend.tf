terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"    # <-- Replace with your S3 bucket name (once created)
    key            = "global/terraform.tfstate"       # <-- Path inside bucket
    region         = "us-west-2"                       # <-- Your AWS region
    dynamodb_table = "state-lock"                      # <-- DynamoDB lock table name
    encrypt        = true
  }
}
