variable "aws_region" {
    description = "AWS region"
    type = string
    default = "us-east-1"
}

variable "lambda_function_name" {
    description = "Name of Lambda Function"
    type = string
    default = "ipa-en-us-lambda"
}

variable "lambda_timeout" {
    description = "Lambda function timeout in seconds"
    type = number
    default = 30
}

variable "lambda_memory_size" {
    description = "Lambda function memory size in MB"
    type = number
    default = 128
}

