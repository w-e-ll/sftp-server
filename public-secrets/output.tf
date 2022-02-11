output "endpoint" {
    value = aws_transfer_server.sftp-server.endpoint
}

output "role" {
    value = alks_iamrole.transfer-server-iam-role.arn
}

output "key_arn" {
  value       = aws_kms_key.key.arn
  description = "The ARN of the customer-managed key"
}