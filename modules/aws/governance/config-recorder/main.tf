module "role" {
  source = "../../identity/iam-role"

  role_name            = var.role_name
  assume_role_services = ["config.amazonaws.com"]
  managed_policy_arns  = ["arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"]
  tags                 = var.tags
}

resource "aws_config_configuration_recorder" "this" {
  name     = "default"
  role_arn = module.role.role_arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "this" {
  name           = "default"
  s3_bucket_name = var.bucket_name

  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.this]
}