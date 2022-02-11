variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "s3_bucket_arn" {
  type        = string
  description = "S3 bucket ARN"
}

variable "transfer_server_name" {
  type        = string
  description = "Name of the transfer server"
}

variable "apigateway-cloudwatchlogs_policy_arn" {
  type        = string
  description = "Api Gateway CloudWatch logs policy ARN"
  default     = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

variable "api_gateway_stage_name" {
  type        = string
  description = "Api Gateway stage name"
  default     = "lab"
}

variable "lambda_logs_idp_policy_arn" {
  type        = string
  description = "Lambda logs Identity Provider ARN"
  default     = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

variable "secret_path_part" {
  type        = string
  description = "Part of the path in Secrets Manager"
  default     = "user-list"
}

variable "secret_id" {
  type        = string
  description = "Secrets Manager secret name"
  default     = "SFTP-SERVER2"
}

variable "boto_service_name" {
  type        = string
  description = "Service to work with Boto"
  default     = "secretsmanager"
}
