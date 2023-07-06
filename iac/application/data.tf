data "terraform_remote_state" "message_broker" {
  backend = "s3"
  config = {
    bucket = "bighead-project3-tfstate"
    key    = "message-broker/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "aws_secretsmanager_secret" "mysql_connection" {
    name = "mysql-connection"
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}