locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "alks_iamrole" "transfer-server-role" {
  name               = "${var.transfer_server_name}-transfer_server_role"
  type               = "AWS Transfer for SFTP"
  include_default_policies = true
}

resource "aws_iam_role_policy" "transfer-server-assume-policy" {
  name               = "${var.transfer_server_name}-transfer_server_policy"
  role               = alks_iamrole.transfer-server-role.name
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SFTPAllowAccesstoS3",
            "Effect": "Allow",
            "Action": [
              "s3:DeleteObject",
              "s3:DeleteObjectVersion",
              "s3:GetBucketLocation",
              "s3:GetObject",
              "s3:GetObjectVersion",
              "s3:ListBucket",
              "s3:PutObject"
            ],
            "Resource": ["${var.s3_bucket_arn}", "${var.s3_bucket_arn}/*"]
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy" "transfer-server-to-cloudwatch-policy" {
  name               = "${var.transfer_server_name}-transfer_server_to_cloudwatch_policy"
  role               = alks_iamrole.transfer-server-role.name
  policy = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [{
			"Sid": "AllowAccesstoCloudWatch",
			"Effect": "Allow",
			"Action": [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
			],
			"Resource": "*"
		}
	]
}
POLICY
}

resource "alks_iamrole" "iam-for-lambda-idp-role" {
  name               = "iam-for-lambda-idp"
  type               = "AWS Lambda"
  include_default_policies = true
}

resource "aws_iam_role_policy_attachment" "iam-for-lambda-idp-policy-attachment" {
  role             = alks_iamrole.iam-for-lambda-idp-role.name
  policy_arn       = var.lambda_logs_idp_policy_arn
}

resource "aws_iam_role_policy" "iam-for-lambda-idp-policy-secrets-manager" {
  name             = "iam-for-lambda-idp-policy-secrets-manager"
  role             = alks_iamrole.iam-for-lambda-idp-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.secret_id}/*"
        }
    ]
}
EOF
}

resource "alks_iamrole" "iam-for-apigateway-idp-role" {
  name               = "iam-for-apigateway-idp-role"
  type               = "Amazon API Gateway"
  include_default_policies = true
}

resource "aws_iam_role_policy_attachment" "iam-for-apigateway-idp-cloudwatchlogs-policy-attachment" {
  role                = alks_iamrole.iam-for-apigateway-idp-role.name
  policy_arn          = var.apigateway-cloudwatchlogs_policy_arn
}
