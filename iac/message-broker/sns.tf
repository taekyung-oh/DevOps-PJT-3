resource "aws_sns_topic" "stock_empty_topic" {
  name = "stock-empty"  
  sqs_success_feedback_sample_rate = 0
  sqs_success_feedback_role_arn = aws_iam_role.sns_success_feedback_role.arn
  sqs_failure_feedback_role_arn = aws_iam_role.sns_failure_feedback_role.arn
}

resource "aws_sns_topic" "stock_retry_email_topic" {
  name = "stock-retry-email"
  sqs_success_feedback_sample_rate = 0
  sqs_success_feedback_role_arn = aws_iam_role.sns_success_feedback_role.arn
  sqs_failure_feedback_role_arn = aws_iam_role.sns_failure_feedback_role.arn
}

resource "aws_sns_topic" "customer_management_topic" {
  name = "customer-management"
  sqs_success_feedback_sample_rate = 0
  sqs_success_feedback_role_arn = aws_iam_role.sns_success_feedback_role.arn
  sqs_failure_feedback_role_arn = aws_iam_role.sns_failure_feedback_role.arn
}

resource "aws_sns_topic_subscription" "stock_empty_subscription" {
  topic_arn = aws_sns_topic.stock_empty_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.stock_queue.arn
}

resource "aws_sns_topic_subscription" "stock_empty_ad_subscription" {
  topic_arn = aws_sns_topic.stock_empty_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.advertisement_queue.arn
}

resource "aws_sns_topic_subscription" "stock_retry_email_subscription" {
  topic_arn = aws_sns_topic.stock_retry_email_topic.arn
  protocol  = "email"
  endpoint  = var.stock-operator-email
}

resource "aws_sns_topic_subscription" "customer_management_subscription" {
  topic_arn = aws_sns_topic.customer_management_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.customer_queue.arn
}