resource "aws_iam_role" "sales_lambda_role" {
  name                = "sales-lambda-role"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
                        , aws_iam_policy.publish_stock_empty_sns.arn
                        , aws_iam_policy.get_big_head_mysql_secret_value.arn]
}

resource "aws_iam_role" "stock_lambda_role" {
  name                = "stock_lambda-role"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
                        , aws_iam_policy.read_stock_sqs.arn]
}

resource "aws_iam_role" "stock_increase_lambda_role" {
  name                = "stock-increase-lambda-role"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
                        , aws_iam_policy.get_big_head_mysql_secret_value.arn]
}

resource "aws_iam_role" "stock_retry_lambda_role" {
  name                = "stock-retry-lambda-role"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
                        , aws_iam_policy.send_stock_sqs.arn
                        , aws_iam_policy.read_stock_dl_sqs.arn]
}

resource "aws_iam_role" "check_ad_lambda_role" {
  name                = "check_ad_lambda_role"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
                        , aws_iam_policy.read_advertisement_sqs.arn]
}

resource "aws_iam_policy" "publish_stock_empty_sns" {
  name = "publish-stock-empty-sns"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sns:Publish"]
        Effect   = "Allow"
        Resource = data.terraform_remote_state.message_broker.outputs.stock_empty_topic_arn
      },
    ]
  })
}

resource "aws_iam_policy" "get_big_head_mysql_secret_value" {
  name = "get-big-head-mysql-secret-value"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["secretsmanager:GetSecretValue"]
        Effect   = "Allow"
        Resource = data.aws_secretsmanager_secret.mysql_connection.arn
      },
    ]
  })
}

resource "aws_iam_policy" "read_stock_sqs" {
  name = "read_stock_sqs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sqs:DeleteMessage", "sqs:ReceiveMessage", "sqs:GetQueueAttributes"]
        Effect   = "Allow"
        Resource = data.terraform_remote_state.message_broker.outputs.stock_queue_arn
      },
    ]
  })
}

resource "aws_iam_policy" "send_stock_sqs" {
  name = "send_stock_sqs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sqs:SendMessage"]
        Effect   = "Allow"
        Resource = data.terraform_remote_state.message_broker.outputs.stock_queue_arn
      },
    ]
  })
}

resource "aws_iam_policy" "read_stock_dl_sqs" {
  name = "read_stock_dl_sqs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sqs:DeleteMessage", "sqs:ReceiveMessage", "sqs:GetQueueAttributes"]
        Effect   = "Allow"
        Resource = data.terraform_remote_state.message_broker.outputs.stock_dead_letter_queue_arn
      },
    ]
  })
}

resource "aws_iam_policy" "read_advertisement_sqs" {
  name = "read-advertisement-sqs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sqs:DeleteMessage", "sqs:ReceiveMessage", "sqs:GetQueueAttributes"]
        Effect   = "Allow"
        Resource = data.terraform_remote_state.message_broker.outputs.advertisement_queue_arn
      },
    ]
  })
}
