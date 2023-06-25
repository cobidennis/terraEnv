module "create_ec2_from_codebase" {
    source = "git::https://github.com/cobidennis/terraCodebase.git"
    bucket = var.bucket
    key =  var.key
    sg_name = var.sg_name
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket = var.bucket
    key    = var.key
    region = "eu-west-1"
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

variable key {}
variable bucket {}
variable sg_name {}