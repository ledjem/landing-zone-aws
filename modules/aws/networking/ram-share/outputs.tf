output "share_arn" {
  description = "ARN du partage RAM"
  value       = aws_ram_resource_share.this.arn
}
