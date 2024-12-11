variable "region" {
  description = "The region in which to create the resources"
  type        = string
}

variable "name" {
  description = "The name of the resources"
  type        = string
}

variable "vpc_id" {
  description = "The id for the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "The ids for the public subnets"
  type        = list(string)
}

variable "target_group_arn" {
  description = "The ARN for the target group"
  type        = string
}

