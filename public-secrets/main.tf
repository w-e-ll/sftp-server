module "sftp-idp" {
  source               = "../identity-provider"
  transfer_server_name = var.transfer_server_name
  s3_bucket_arn        = var.s3_bucket_arn
}