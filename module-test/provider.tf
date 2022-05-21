terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }

  backend "s3" {
    bucket = "terraform-states-vst-us-east-1"
    key    = "tf-module-test/aws-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  alias  = "nvirginia"
  region = "us-east-1"
}

provider "aws" {
  alias  = "frankfurt"
  region = "eu-central-1"
}
