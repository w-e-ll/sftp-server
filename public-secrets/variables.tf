data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "aws_s3_bucket_name" {
  type        = string
  description = "S3 bucket name"
  default     = "sftp.home.url"
}

variable "aws_s3_bucket_acl" {
  type        = string
  description = "S3 bucket ACL type"
  default     = "private"
}

variable "s3_bucket_arn" {
  type        = string
  description = "S3 bucket ARN"
  default     = "arn:aws:s3:::sftp.home.url"
}

# Options available
# SYMMETRIC_DEFAULT, RSA_2048, RSA_3072,
# RSA_4096, ECC_NIST_P256, ECC_NIST_P384,
# ECC_NIST_P521, or ECC_SECG_P256K1
variable key_spec {
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable enabled {
  default     = true
}

variable rotation_enabled {
  default     = true
}

variable alias {
  default     = "sftp-ssm"
}

variable policy {
  default     = null
}

variable "secrets_manager_name" {
  type        = string
  description = "Secrets Manager name"
  default     = "SFTP-SERVER2"
}

variable "secrets_manager_name_suffix" {
  type        = string
  description = "Secrets Manager suffix"
  default     = "user-list"
}

variable "transfer_server_name" {
  type        = string
  description = "sFTP server name"
  default     = "sftp-server-1"
}

variable "transfer_server_tag_name" {
  type        = string
  description = "sFTP server Tag name"
  default     = "sftp-server"
}

variable "identity_provider_type" {
  type        = string
  description = "Identity provider type"
  default     = "API_GATEWAY"
}

variable "endpoint_type" {
  type        = string
  description = "sFTP server endpoint type"
  default     = "PUBLIC"
}
