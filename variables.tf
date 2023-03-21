variable "snowflake_password" {
  description = "The password to use for the Snowflake Loader (keep it secret!)"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
}

variable "aws_assume_role_arn" {
  description = "The AWS role that will be assumed to deploy the infrastructure"
  type        = string
}

variable "aws_iam_permissions_boundary" {
  description = "The permissions boundary ARN to set on IAM roles created (can be empty if you do not require one in your AWS account)"
  type        = string
}

variable "user_provided_id" {
  description = "An optional unique identifier to identify the telemetry events emitted by this stack"
  type        = string
}

variable "telemetry_enabled" {
  description = "Whether or not to send telemetry information back to Snowplow Analytics Ltd"
  type        = bool
  default     = true
}
