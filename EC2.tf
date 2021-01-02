provider "aws" {

  version = "~>2.65"
  region  = "ap-south-1"

}

resource "aws_instance" "ec2_terraform" {

  ami           = " ami-0a9d27a9f4f5c0efc"
  instance_type = "t2.micro"
}
