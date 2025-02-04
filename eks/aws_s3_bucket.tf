# Make sure to have your S3 created before creating other resource

# terraform {
#  required_version = ">= 1.4.0"
#  backend "s3" {
#    bucket         = "wp-terraform-s3-state"
#    key            = "eks/eks-cluster.tfstate"
#    region         = "us-east-1"
#    encrypt        = true
#  }
#}