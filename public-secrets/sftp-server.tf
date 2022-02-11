resource "aws_transfer_server" "sftp-server" {
  identity_provider_type = var.identity_provider_type
  logging_role           = alks_iamrole.sftp-server-log-role.arn
  url                    = module.sftp-idp.invoke_url
  invocation_role        = alks_iamrole.sftp-server-idp-role.arn
  endpoint_type          = var.endpoint_type

  tags = {
    NAME                 = var.transfer_server_tag_name
  }
}
