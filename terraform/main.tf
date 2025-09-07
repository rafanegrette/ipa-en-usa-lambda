data "aws_caller_identity" "current" {}

data "archive_file" "lambda_zip" {
  type = "zip"
  source_dir = "${path.module}/../src"
  output_path = "${path.module}/lambda-deployment.zip"
}

resource "aws_iam_role" "lambda_role" {
    name = "${var.lambda_function_name}-role"
  
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })

    tags = {
      Project = var.lambda_function_name
    }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda_role.name
}

resource "aws_lambda_function" "main" {
  filename = data.archive_file.lambda_zip.output_path
  function_name = var.lambda_function_name
  role = aws_iam_role.lambda_role.arn
  handler = "index.handler"
  runtime = "nodejs22.x"
  timeout = var.lambda_timeout
  memory_size = var.lambda_memory_size

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = {
      Project = var.lambda_function_name
    }
}

resource "aws_lambda_function_url" "main" {
  function_name = aws_lambda_function.main.function_name
  authorization_type = "AWS_IAM"

  cors {
    allow_credentials = true
    allow_origins = ["*"]
    allow_methods = ["POST"]
    allow_headers = ["date", "keep-alive", "content-type", "authorization"]
    expose_headers = ["date", "keep-alive"]
    max_age = 86400
  }
}