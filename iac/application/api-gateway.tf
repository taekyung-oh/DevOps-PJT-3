resource "aws_apigatewayv2_api" "sales_apigateway" {
  name          = "sales-apigateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "sales_apigateway_integration" {
  api_id              = aws_apigatewayv2_api.sales_apigateway.id
  integration_type    = "AWS_PROXY"
  integration_method  = "POST"
  integration_uri     = aws_lambda_function.sales_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "sales_apigateway_route" {
  api_id    = aws_apigatewayv2_api.sales_apigateway.id
  route_key = "$default"
  target = "integrations/${aws_apigatewayv2_integration.sales_apigateway_integration.id}"
}

resource "aws_apigatewayv2_stage" "sales_apigateway_stage" {
  api_id = aws_apigatewayv2_api.sales_apigateway.id
  name   = "sales_api_stage"
}

resource "aws_apigatewayv2_api" "stock_apigateway" {
  name          = "stock-apigateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "stock_apigateway_integration" {
  api_id              = aws_apigatewayv2_api.stock_apigateway.id
  integration_type    = "AWS_PROXY"
  integration_method  = "POST"
  integration_uri     = aws_lambda_function.stock_increase_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "stock_apigateway_route" {
  api_id    = aws_apigatewayv2_api.stock_apigateway.id
  route_key = "$default"
  target = "integrations/${aws_apigatewayv2_integration.stock_apigateway_integration.id}"
}

resource "aws_apigatewayv2_stage" "stock_apigateway_stage" {
  api_id = aws_apigatewayv2_api.stock_apigateway.id
  name   = "stock_api_stage"
}