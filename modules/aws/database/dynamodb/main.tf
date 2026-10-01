locals {
  env_suffix      = var.environment != "" ? "-${var.environment}" : ""
  resource_prefix = "${var.name_prefix}${local.env_suffix}"

  table_name = var.override_table_name != "" ? var.override_table_name : local.resource_prefix
}

resource "aws_dynamodb_table" "this" {
  name         = local.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  tags = merge(var.tags, { Name = "${local.resource_prefix}-table" })
}
