terraform {
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
  alias  = "ireland"
  region = "eu-west-1"
}
