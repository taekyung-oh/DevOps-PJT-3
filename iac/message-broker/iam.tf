resource "aws_iam_role" "sns_success_feedback_role" {
  name                = "sns-success-feedback-role"
  assume_role_policy  = data.aws_iam_policy_document.sns_assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.put_sns_feedback.arn]
}

resource "aws_iam_role" "sns_failure_feedback_role" {
  name                = "sns-failure-feedback-role"
  assume_role_policy  = data.aws_iam_policy_document.sns_assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.put_sns_feedback.arn]
}

resource "aws_iam_policy" "put_sns_feedback" {
  name = "put_sns_feedback"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"
                   ,"logs:PutMetricFilter", "logs:PutRetentionPolicy"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}