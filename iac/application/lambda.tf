resource "aws_lambda_function" "sales_lambda" {
  function_name = "sales"
  role          = aws_iam_role.sales_lambda_role.arn
  s3_bucket     = "bighead-project3-lambda"
  s3_key        = "sales/sales.zip"
  handler       = "handler.js"
  runtime       = "nodejs14.x"

  environment {
    variables = {
      SECRET_MANAGER_ARN = data.aws_secretsmanager_secret.mysql_connection.arn
      TOPIC_ARN = data.terraform_remote_state.message_broker.outputs.stock_empty_topic_arn
    }
  }
}

resource "aws_lambda_permission" "sales_lambda_permission" {
  statement_id  = "AllowSalesAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sales_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.sales_apigateway.execution_arn}/*"
}

resource "aws_lambda_function" "stock_lambda" {
  function_name = "stock"
  role          = aws_iam_role.stock_lambda_role.arn
  s3_bucket     = "bighead-project3-lambda"
  s3_key        = "stock/stock.zip"
  handler       = "index.js"
  runtime       = "nodejs18.x"
}

resource "aws_lambda_event_source_mapping" "stock_lambda_source" {
  event_source_arn = data.terraform_remote_state.message_broker.outputs.stock_queue_arn
  function_name    = aws_lambda_function.stock_lambda.arn
}

resource "aws_lambda_function" "stock_increase_lambda" {
  function_name = "stock-increase"
  role          = aws_iam_role.stock_increase_lambda_role.arn
  s3_bucket     = "bighead-project3-lambda"
  s3_key        = "stock-increase/stock_increase.zip"
  handler       = "handler.js"
  runtime       = "nodejs14.x"

  environment {
    variables = {
      SECRET_MANAGER_ARN = data.aws_secretsmanager_secret.mysql_connection.arn
    }
  }
}

resource "aws_lambda_permission" "stock_increase_lambda_permission" {
  statement_id  = "AllowStockIncreaseAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stock_increase_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.stock_apigateway.execution_arn}/*"
}

resource "aws_lambda_function" "stock_retry_lambda" {
  function_name = "stock_retry"
  role          = aws_iam_role.stock_retry_lambda_role.arn
  s3_bucket     = "bighead-project3-lambda"
  s3_key        = "stock-retry/stock_retry.zip"
  handler       = "handler.js"
  runtime       = "nodejs14.x"
}

resource "aws_lambda_event_source_mapping" "stock_retry_source" {
  event_source_arn = data.terraform_remote_state.message_broker.outputs.stock_dead_letter_queue_arn
  function_name    = aws_lambda_function.stock_retry_lambda.arn
}

resource "aws_lambda_function" "check_ad_lambda" {
  function_name = "check_ad"
  role          = aws_iam_role.check_ad_lambda_role.arn
  s3_bucket     = "bighead-project3-lambda"
  s3_key        = "check-ad/check_ad.zip"
  handler       = "handler.js"
  runtime       = "nodejs14.x"
}

resource "aws_lambda_event_source_mapping" "check_ad_source" {
  event_source_arn = data.terraform_remote_state.message_broker.outputs.advertisement_queue_arn
  function_name    = aws_lambda_function.check_ad_lambda.arn
}