output "sales_lambda_invoke_arn" {
  description = "Invoke ARN of the Sales Lambda"
  value       = aws_lambda_function.sales_lambda.invoke_arn
}
