data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "archive_file" "sftp-idp-data" {
  type             = "zip"
  source_dir       = "${path.module}/lambda/"
  output_path      = "${path.module}/sftp-idp.zip"
}

resource "aws_lambda_function" "sftp-idp" {
  filename         = "${path.module}/sftp-idp.zip"
  function_name    = "sftp-idp"
  role             = alks_iamrole.iam-for-lambda-idp-role.arn
  handler          = "index.lambda_handler"
  source_code_hash = data.archive_file.sftp-idp-data.output_base64sha256
  runtime          = "python3.6"

  environment {
    variables = {
      path_part    = var.secret_path_part
      path_part    = var.secret_path_part
      secret_id    = var.secret_id
      region       = var.aws_region
      service_name = var.boto_service_name
    }
  }
}



