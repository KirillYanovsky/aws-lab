terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  # backend "s3" {
  #   bucket         = "300732800381-tfstate"
  #   key            = "aws-lab.tfstate"
  #   region         = "eu-central-1"
  #   dynamodb_table = "aws-lab-terraform-state-locking"
  # }
}
