variable "region" {
  description = "The region in which to create the network"
  type        = string
}

variable "name" {
  description = "The name of the environment"
  type        = string
}

variable "vpc_id" {
  description = "The id for the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs for the private subnets"
  type        = list(string)
}

variable "frontend_sg_id" {
  description = "The security group ID for the frontend alb"
  type        = string
}

variable "backend_instance_type" {
  description = "The instance type for the backend instances"
  type        = string
}

variable "desired_capacity" {
  description = "The desired capacity for the autoscaling group"
  type        = number
}

variable "scaling_range" {
  description = "The scaling range for the autoscaling group"
  type        = list(number)
}

variable "user_data" {
  description = "The user data for the backend instances"
  type        = string
}

