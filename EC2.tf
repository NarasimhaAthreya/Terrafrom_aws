provider "aws" {
  region     = "ap-south-1"
  access_key = var.tf_access_key
  secret_key = var.tf_secret_key
}

locals {
  setup_name = "terraform"
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.5.0.0/16"

  tags = {
    "Name" = "terraform_vpc"
  }
}
resource "aws_subnet" "terraform_subnet" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.5.0.0/16"
  tags = {
    Name = "terraform_subnet"
  }
}
resource "aws_instance" "ec2_terraform" {
  ami           = "ami-0a9d27a9f4f5c0efc"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.terraform_subnet.id
  tags = {
    Name    = "Terraform AWS"
    Updated = "${local.setup_name}"
  }
}

output "Instance_IP" {

  value = aws_instance.ec2_terraform

}
