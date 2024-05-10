terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
  }
    backend "s3" {
    bucket         = "project-backend-bucket-bc564t78235d"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tfstate-lock"
    encrypt        = true
  }
}

provider "aws" {
  profile = local.provider.profile
  region  = local.provider.region
}