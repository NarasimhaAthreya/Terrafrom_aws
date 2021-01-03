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


resource "aws_lambda_function" "terraform_lamda" {

  filename         = "app.zip"
  function_name    = "terraform_lamda"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "app.handlers"
  source_code_hash = filebase64sha256("app.zip")
  runtime          = "nodejs12.x"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_api_gateway_rest_api" "terraform_apigateway" {
  name        = "terraform_apigateway"
  description = "This is my API for demonstration purposes"

}

resource "aws_api_gateway_resource" "terraform_resource" {
  rest_api_id = aws_api_gateway_rest_api.terraform_apigateway.id
  parent_id   = aws_api_gateway_rest_api.terraform_apigateway.root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_method" "terraform_method" {
  rest_api_id   = aws_api_gateway_rest_api.terraform_apigateway.id
  resource_id   = aws_api_gateway_resource.terraform_resource.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "terraform_integration" {
  rest_api_id             = aws_api_gateway_rest_api.terraform_apigateway.id
  resource_id             = aws_api_gateway_resource.terraform_resource.id
  http_method             = aws_api_gateway_method.terraform_method.http_method
  integration_http_method = "GET"
  uri                     = aws_lambda_function.terraform_lamda.invoke_arn
}

resource "aws_api_gateway_method_response" "terraform_response" {
  rest_api_id = aws_api_gateway_rest_api.terraform_apigateway.id
  resource_id = aws_api_gateway_resource.terraform_resource.id
  http_method = aws_api_gateway_method.terraform_method.method
  status_code = "200"
}
output "Instance_IP" {

  value = aws_instance.ec2_terraform

}
