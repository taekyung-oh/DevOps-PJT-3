output "stock_queue_arn" {
  description = "ARN of the Stock Queue"
  value       = aws_sqs_queue.stock_queue.arn
}

output "stock_dead_letter_queue_arn" {
  description = "ARN of the Stock Dead Letter Queue"
  value       = aws_sqs_queue.stock_dead_letter_queue.arn
}

output "advertisement_queue_arn" {
  description = "ARN of the Advertisement Queue"
  value       = aws_sqs_queue.advertisement_queue.arn
}

output "stock_empty_topic_arn" {
  description = "ARN of the Stock Empty Topic"
  value       = aws_sns_topic.stock_empty_topic.arn
}