provider "aws" {
  access_key = "AKIAJYTHBJ3MWPFGU62A"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_instance" "terraform_agent" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
 
tags {
     Name = "Terraform_Agent"
     }
}
   
