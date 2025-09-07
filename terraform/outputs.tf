output "lambda_function_name" {
    description = "Name of the Lambda function"
    value = aws_lambda_function.main.function_name
}

output "lambda_function_arn" {
    description = "ARN of the Lambda function"
    value = aws_lambda_function.main.arn
}

output "lambda_function_url" {
    description = "URL of the application"
    value = aws_lambda_function_url.main.function_url
}

output "lambda_function_invoke_arn" {
    description = "Invoke ARN of the Lambda function"
    value = aws_lambda_function.main.invoke_arn
}
