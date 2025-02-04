variable "region" {
  default = "us-east-1"
}

variable "clusterName" {
  default = "wordpress-cluster"
}

variable "rds_username" {
  default = "admin"
}

variable "rds_password" {
  default = "Admin123!"
}

variable "cluster_version" {
  type        = string
  default     = "1.28"
  description = "EKS cluster version"
}

variable "subnet_ids" {
  type        = list(string)
  default     = ["subnet-03b9e9eb667e4d8ad", "subnet-0a22cbddc73843e9a"]
  description = "List of subnet IDs"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-03c85705c6b881928"
  description = "VPC ID for EKS"
}

variable "tags" {
  type        = map(string)
  default     = {
    Owner       = "ganapathy@ganapathy.com"
    Project     = "Lab"
    Application = "OaaS"
    Name        = "wordpress-eks"
    Environment = "test"
  }
  description = "Resource tags"
}

variable "NodeCount" {
  type        = number
  default     = 1
  description = "Number of nodes in the EKS node group"
}

variable "s3_bucket_name" {
  type        = string
  default     = "wp-terraform-state-bucket"
  description = "S3 bucket for Terraform state"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR block"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "instance_types" {
  type = list(string)
  default = ["t3.large", "t3.medium", "m5.large", "m5.xlarge"]
  description = "List of instance types for the EKS managed node group."
}
