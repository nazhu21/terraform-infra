provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    # bucket         = "nazhu21-project-x-state-bucket-staging"
    key    = "terraform.tfstate"
    region = "us-east-1"
    #dynamodb_table = "terraformlock"
  }
}

