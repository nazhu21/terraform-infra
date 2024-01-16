# DO NOT RELY ON STATE FILE FOR THE FILES IN THIS FOLDER
# TREAT THESE RESOURCES AS BEING CREATED MANUALLY AND STATE NOT BEING MANAGED IN TERRAFORM
# ALTERNATIVELY, YOU CAN JUST CREATE BUCKET MANUALLY IN AWS CONSOLE WITH DESIRED SETTINGS
resource "aws_s3_bucket" "statebucket" {
  bucket = "nazhu21-project-x-state-bucket-production"

  tags = {
    Name        = "Terraform State bucket for Project X"
    Environment = "Prod"
  }
}

provider "aws" {
  region = "us-east-1"
}


# resource "aws_dynamodb_table" "basic-dynamodb-table" {
#   name           = "terraformlock"
#   billing_mode   = "PAY_PER_REQUEST"
#   hash_key       = "LockID"
#   attribute {
#       name = "LockID"
#       type = "S"
#   }

#   tags = {
#     Name        = "dynamodb-lock-table"
#     Environment = "dev"
#   }
# }