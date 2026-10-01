resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_id
  policy = var.policy_json
}
