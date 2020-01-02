provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "tutor-dev-tf-state-bucket"
    key    = "terraform-state/terraform.tfstate"
    region = "eu-west-1"
  }
}

locals {
    prefix = var.prefix
}

module "infrastructure" {
    source = "./modules/Infrastructure"
    prefix = local.prefix
}