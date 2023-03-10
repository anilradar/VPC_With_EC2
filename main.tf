terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.38.0"
    }
  }
}

provider "aws" {
  access_key = "AKIATS4SFX37CYCEUOBF"
  secret_key = "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"
  region     = "us-east-1"
}


# resource "aws_instance" "app_server" {
#   ami           = "ami-09d3b3274b6c5d4aa"
#   instance_type = "t2.micro"
#   key_name       = "AWS_DevOps_KP"

#   tags = {
#     Name = "MyTFinstance"
#   }
# }




