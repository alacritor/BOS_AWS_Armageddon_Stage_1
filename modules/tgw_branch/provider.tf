terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.default, aws.tokyo]
    }
  }
}

data "aws_caller_identity" "region" {
}

data "aws_caller_identity" "tokyo" {
  provider = aws.tokyo
}