locals {
  admin_username = "tester"
  account_id     = data.aws_caller_identity.current.account_id
}

resource "alks_iamrole" "sftp-server-idp-role" {
  name = "sftp-server-iam-role"
  type = "AWS Transfer for SFTP"
  include_default_policies = true
}

resource "aws_iam_role_policy" "sftp-server-idp-invoke-policy" {
  name = "sftp-server-iam-invoke-policy"
  role = alks_iamrole.sftp-server-idp-role.id

  policy = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "InvokeApi",
			"Effect": "Allow",
			"Action": [
				"execute-api:Invoke"
			],
			"Resource": "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${module.sftp-idp.rest_api_id}/${module.sftp-idp.rest_api_stage_name}/GET/*"
		},
		{
			"Sid": "ReadApi",
			"Effect": "Allow",
			"Action": [
				"apigateway:GET"
			],
			"Resource": "*"
		}
	]
}
POLICY
}

resource "alks_iamrole" "sftp-server-log-role" {
  name = "sftp-server-iam-log-role"
  type = "AWS Transfer for SFTP"
  include_default_policies = true
}

resource "aws_iam_role_policy" "sftp-server-log-policy" {
  name = "sftp-server-iam-log-policy"
  role = alks_iamrole.sftp-server-log-role.id
  policy = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [{
			"Sid": "AllowFullAccesstoCloudWatchLogs",
			"Effect": "Allow",
			"Action": [
              "logs:CreateLogStream",
              "logs:DescribeLogStreams",
              "logs:CreateLogGroup",
              "logs:PutLogEvents"
			],
			"Resource": "*"
		}
	]
}
POLICY
}

resource "alks_iamrole" "transfer-server-iam-role" {
  name = "transfer-server-iam-role"
  type = "AWS Transfer for SFTP"
  include_default_policies = true
}

resource "aws_iam_role_policy" "transfer-server-iam-policy-s3-access" {
  name = "transfer-server-iam-policy-s3-access"
  role = alks_iamrole.transfer-server-iam-role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowFullAccesstoS3",
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
            "Resource": ["${aws_s3_bucket.bucket.arn}","${aws_s3_bucket.bucket.arn}/*"]
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy" "transfer-server-iam-policy-kms-access" {
  name = "transfer-server-iam-policy-kms-access"
  role = alks_iamrole.transfer-server-iam-role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:GenerateDataKey",
                "kms:Decrypt"
            ],
            "Resource": ["arn:aws:kms:${var.region}:${local.account_id}:key/${aws_kms_key.key.id}"]
        }
    ]
}
POLICY
}

data "aws_iam_policy_document" "ssm-key" {
  statement {
    sid                    = "Enable IAM User Permissions"
    effect                 = "Allow"
    actions                = ["kms:*"]
    resources              = ["*"]

    principals {
      type                 = "AWS"
      identifiers          = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  statement {
    sid                    = "Allow access for Key Administrators"
    effect                 = "Allow"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources              = ["*"]

    principals {
      type                 = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:user/${local.admin_username}"
      ]
    }
  }

  statement {
    sid                    = "Allow use of the key"
    effect                 = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    principals {
      type                 = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:user/${local.admin_username}"
      ]
    }
  }

  statement {
    sid                    = "Allow attachment of persistent resources"
    effect                 = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources              = ["*"]

    principals {
      type                 = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:user/${local.admin_username}"
      ]
    }

    condition {
      test                 = "Bool"
      variable             = "kms:GrantIsForAWSResource"
      values               = ["true"]
    }
  }
}