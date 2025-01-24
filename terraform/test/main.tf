resource "aws_s3_bucket" "terraform_state" {
  bucket = "kubecluster-tf-state"
}

module "vpc" {
  source = "../modules/vpc"

  namespace   = var.namespace
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  az_count    = var.az_count
}
