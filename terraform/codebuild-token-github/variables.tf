variable "aws_profile" {
  type        = string
  description = "Local aws credential profile"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS account region to create the SSM parameter in"

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

variable "github_token" {
  type        = string
  description = "Github personal access token"
  sensitive   = true
}