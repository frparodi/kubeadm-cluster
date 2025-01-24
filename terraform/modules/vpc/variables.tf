#####################################################################################################################################
# General
#####################################################################################################################################

variable "namespace" {
  description = "Namespace for resource names"
  type        = string
}

variable "environment" {
  description = "Infrastructure environment (dev, staging, prod, etc.)"
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
