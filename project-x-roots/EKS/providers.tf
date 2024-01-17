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

# data "aws_eks_cluster" "cluster" {
#   name = var.cluster_name
# }

# data "aws_eks_cluster_auth" "cluster_auth" {
#   name = var.cluster_name
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.cluster_auth.token
# }

