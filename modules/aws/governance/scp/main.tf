resource "aws_organizations_policy" "this" {
  name    = var.name
  content = var.policy_json
  type    = var.type
}

resource "aws_organizations_policy_attachment" "this" {
  policy_id = aws_organizations_policy.this.id
  target_id = var.target_id
}