resource "aws_sqs_queue" "stock_queue" {
  name                       = "stock-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  delay_seconds              = 0
  max_message_size           = 262144
  receive_wait_time_seconds  = 0  
}

resource "aws_sqs_queue" "stock_dead_letter_queue" {
  name                       = "stock-dead-letter-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  delay_seconds              = 0
  max_message_size           = 262144
  receive_wait_time_seconds  = 0
}

resource "aws_sqs_queue_redrive_policy" "stock_queue_redrive_policy" {
  queue_url = aws_sqs_queue.stock_queue.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.stock_dead_letter_queue.arn
    maxReceiveCount     = 10
  })
}

resource "aws_sqs_queue_redrive_allow_policy" "stock_queue_redrive_allow_policy" {
  queue_url = aws_sqs_queue.stock_dead_letter_queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.stock_queue.arn]
  })
}

resource "aws_sqs_queue" "advertisement_queue" {
  name                       = "advertisement-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  delay_seconds              = 0
  max_message_size           = 262144
  receive_wait_time_seconds  = 0
}

resource "aws_sqs_queue" "advertisement_dead_letter_queue" {
  name                       = "advertisement-dead-letter-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  delay_seconds              = 0
  max_message_size           = 262144
  receive_wait_time_seconds  = 0
}

resource "aws_sqs_queue_redrive_policy" "advertisement_queue_redrive_policy" {
  queue_url = aws_sqs_queue.advertisement_queue.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.advertisement_dead_letter_queue.arn
    maxReceiveCount     = 10
  })
}

resource "aws_sqs_queue_redrive_allow_policy" "advertisement_queue_redrive_allow_policy" {
  queue_url = aws_sqs_queue.advertisement_dead_letter_queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.advertisement_queue.arn]
  })
}

resource "aws_sqs_queue" "customer_queue" {
  name                       = "customer-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  delay_seconds              = 0
  max_message_size           = 262144
  receive_wait_time_seconds  = 0
}

resource "aws_sqs_queue" "customer_dead_letter_queue" {
  name                       = "customer-dead-letter-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  delay_seconds              = 0
  max_message_size           = 262144
  receive_wait_time_seconds  = 0
}

resource "aws_sqs_queue_redrive_policy" "customer_queue_redrive_policy" {
  queue_url = aws_sqs_queue.customer_queue.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.customer_dead_letter_queue.arn
    maxReceiveCount     = 10
  })
}

resource "aws_sqs_queue_redrive_allow_policy" "customer_queue_redrive_allow_policy" {
  queue_url = aws_sqs_queue.customer_dead_letter_queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.customer_queue.arn]
  })
}