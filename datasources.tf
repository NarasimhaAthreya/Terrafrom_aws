data "aws_ami" "aws_ec2" {

  owners      = ["309956199498"]
  most_recent = true


  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["arm64", "x86_64"]
  }

}