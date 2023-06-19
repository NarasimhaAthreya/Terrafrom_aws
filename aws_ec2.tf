

resource "aws_instance" "tf-ec2-1" {

  ami           = data.aws_ami.aws_ec2.image_id
  instance_type = var.aws_instance_type


  tags = {
    "Name"       = var.ec2_names[count.index]
    "instanceNo" = "${count.index}" + 1
  }

  count = 2
}


output "aws_ec2_values" {

 value = {
    for k, v in aws_instance.tf-ec2-1 : k => v.public_ip
  }
}