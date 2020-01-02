variable "prefix" {
  default = "dev"
}

resource "aws_dynamodb_table" "available-times-dynamodb-table" {
  name           = "${var.prefix}-available-times-dynamo-db"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 3
  write_capacity = 3
  hash_key       = "AvailableTimes"
  range_key      = "Day"

  attribute {
    name = "AvailableTimes"
    type = "N"
  }

  attribute {
    name = "Day"
    type = "S"
  }
}

resource "aws_sns_topic" "sms_receive_sns" {
  name = "${var.prefix}-sms-receive-sns"
}

resource "aws_sqs_queue" "sms_receive_sqs" {
  name                      = "${var.prefix}-sms-receive-sqs"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}

resource "aws_sns_topic_subscription" "sms_receive_sqs_subscriber" {
  topic_arn = aws_sns_topic.sms_receive_sns.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sms_receive_sqs.arn
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "available_times_lambda" {
  filename      = "../../lambda_zips/AvailableTimes.zip"
  function_name = "${var.prefix}-available_times_dynamo"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "index.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("../../lambda_zips/AvailableTimes.zip")}"

  runtime = "nodejs10.x"
}