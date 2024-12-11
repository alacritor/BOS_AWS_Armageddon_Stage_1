variable "region" {
  description = "The region in which to create the network"
  type        = string
}

variable "name" {
  description = "The name of the environment"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "tgw_id" {
  description = "Transit Gateway ID"
  type        = string
}

