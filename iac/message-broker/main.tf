terraform {
  # Location of message-broker state file
  backend "s3" {
    bucket  = "bighead-project3-tfstate"
    key     = "message-broker/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-2"
}