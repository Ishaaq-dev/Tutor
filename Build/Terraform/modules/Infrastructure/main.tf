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

resource "aws_sns_topic" "sms-receive-sns" {
  name = "${var.prefix}-sms-receive-sns"
}

resource "aws_sqs_queue" "terraform_queue" {
  name                      = "${var.prefix}-sms-receive-sqs"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}