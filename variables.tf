variable "AWS_KEY" {
  type = string
}

variable "AWS_PWD" {
  type = string
}

variable "aws_region" {
  default = "us-east-1"

}

variable "aws_instance_type" {
  default = "t2.micro"

}

variable "aws_ami" {
  type = string

}

variable "ec2_names" {

  type    = list(string)
  default = ["prod"]

}