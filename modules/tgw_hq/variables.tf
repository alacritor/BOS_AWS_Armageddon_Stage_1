variable "region" {
  type        = string
  description = "Region for resources to be created"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

