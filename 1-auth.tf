terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "armageddon-tf-backend-x1"     # Name of the S3 bucket
    key     = "armageddon-modules-2.tfstate" # The name of the state file in the bucket
    region  = "us-east-1"                    # Use a variable for the region
    encrypt = true                           # Enable server-side encryption (optional but recommended)
  }
}

