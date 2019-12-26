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