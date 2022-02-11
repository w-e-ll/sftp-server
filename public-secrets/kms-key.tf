resource "aws_kms_key" "key" {
  description              = "This key is used to encrypt bucket objects"
  customer_master_key_spec = var.key_spec
  is_enabled               = var.enabled
  enable_key_rotation      = var.rotation_enabled
  policy                   = data.aws_iam_policy_document.ssm-key.json
  deletion_window_in_days  = 7
}

resource "aws_kms_alias" "key" {
  name                     = "alias/${var.alias}"
  target_key_id            = aws_kms_key.key.id
}
