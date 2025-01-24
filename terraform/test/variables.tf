#####################################################################################################################################
# General
#####################################################################################################################################

variable "namespace" {
  description = "Namespace for resource names"
  type        = string
  default     = "kubecluster"
}

variable "environment" {
  description = "Infrastructure environment"
  type        = string
}


variable "aws_region" {
  description = "Region in which AWS Resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

#####################################################################################################################################
# VPC
#####################################################################################################################################

variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type        = string
}

variable "az_count" {
  description = "How many availability zones are used"
  type        = number
  default     = 2 
}
