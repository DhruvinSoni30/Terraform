#Terraform file to spawn an EC2 instance and install git in it.


provider "aws"
 {
  access_key = "YOUR_ACCESS_KEY"
  secret_key = "YOUR_SECRET_KEY"
  region     = "us-east-1"
 } 
 
 #Creation of security groups
resource "aws_security_group" "default"
 {
  name = "terraform-group"
  vpc_id = "vpc-ea62f590"  
  
#inboud rules
#To allow tarffic from 8080 port.
ingress
 {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  
#outbound rules  
egress
    {
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
    } 
    
#inbound rules
#To allow SSH connection.
ingress
 {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
#outbound rules  
egress
    {
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
    }
    
tags{
    Name = "Allow"
    }
}

#Private key for connection over SSH
resource "aws_key_pair" "auth" {
  key_name   = "id_rsa"
  public_key = "${file("/home/ubuntu/.ssh/id_rsa.pub")}"
}

#Creation of EC2 instance
resource "aws_instance" "Terraform_Demo"
{        
   ami = "ami-2757f631"
   instance_type = "t2.micro"
   vpc_security_group_ids = ["${aws_security_group.default.id}"]
   key_name = "${aws_key_pair.auth.id}"  

#Connection details
connection
{
   user = "ubuntu"
   private_key = "${file("/home/ubuntu/terraform_demo/mainterraform.pem")}"
}   

#Tag of our instance
tags
{
   Name = "Terraform_Agent"
}

#Excecute commands over SSH
provisioner "remote-exec" {
    inline = [
      "sudo apt-get install git -y"
    ]
  }
 }
