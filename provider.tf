terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47.0"
    }
  }

  required_version = "~> 1.3"
}

provider "aws" {
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "postech-5soat-grupo-25-tfstate"
    key            = "eks/state"
    region         = "us-east-1"
    dynamodb_table = "postech-5soat-grupo-25-tflocks"
    encrypt        = true
  }
}