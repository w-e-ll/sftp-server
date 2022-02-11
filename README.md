# aws-transfer-server

Terraform Module for AWS Transfer for SFTP.  

Terraform module to create and manage a single Amazon Transfer for SFTP backed by an S3 bucket with custom identity provider.

By default, the module creates and manages the S3 bucket but can use an existing externally managed bucket as well.

The module also creates custom identity provider to authenticate users by password/name or ssh key pair. 

Because AWS Transfer is backed by S3, what appear to be directories in SFTP are actually S3 prefixes which follow the pattern <s3_bucket_name>/<DeskSOA_prefix><username>.

List of partners you can find in secrets-manager.tf file. Uncomment it to create Secrets Manager secret with given users to work with SFTP.

This Module will optionally create two Route53 CNAME Records for the server endpoint:

- sftp.apis.dealertrack.com
- sftp-uat.apis.dealertrack.com


## Usage
```hcl-terraform
module "sftp-idp" {
  source               = "../identity-provider"
  transfer_server_name = var.transfer_server_name
  s3_bucket_arn        = var.s3_bucket_arn
}

cd public-secrets
terraform init
terraform apply
```


## ToDo
- Create/Describe IAM User with two policies in your ACCOUNT
  - transfer-server-iam-policy-s3-access
  - transfer-server-iam-policy-kms-access
  to be able co communicate PDBatch with S3 and KMS
  
- Buy domain names to have routes
- CI/CD

## Terraform Versions
This module supports Terraform 0.12.24

## Authors
Module managed by 
https://w-e-ll.com
