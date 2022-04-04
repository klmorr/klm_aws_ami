variable "aws_profile" {
  type        = string
  description = "AWS credential profile, currently used for local testing"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS account region, currently used for local testing"

  validation {
    condition = (contains([
      "us-east-1",
      "us-east-2",
      "us-west-1",
      "us-west-2"
    ], var.aws_region))
    error_message = "Value must be in the allowed regions list."
  }
}

variable "build_timeout" {
  type        = number
  description = "Time in minutes forAWS CodeBuild to wait until timing out any related build that does not get marked as completed"
  default     = 30
}
variable "prefix" {
  type        = string
  description = "prefix for all resource names"
}

variable "s3_bucket_acl" {
  type        = string
  description = "ACL for s3 artifacts bucket"
  default     = "private"

  validation {
    condition = (contains([
      "authenticated-read",
      "aws-exec-read",
      "log-delivery-write",
      "private",
      "public-read-write",
    ], var.s3_bucket_acl))
    error_message = "Value must be in the allowed acl list."
  }
}

variable "project_name" {
  type        = string
  description = "Name for the codebuild project"
}

variable "github_location" {
  type        = string
  description = "Github uri for source code"
}
variable "github_branch" {
  type        = string
  description = "Github branch for source code"
  default     = "main"
}

variable "tags" {
  type        = map(any)
  description = "Resource tags"
}