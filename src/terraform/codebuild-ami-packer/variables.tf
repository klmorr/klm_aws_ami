variable "build_timeout" {
  type        = number
  description = "Time in minutes forAWS CodeBuild to wait until timing out any related build that does not get marked as completed"
  default     = 30
}

variable "github_location" {
  type        = string
  description = "Github uri for source code"
  default     = "https://github.com/klmorr/klm_aws_ami.git"
}
variable "github_branch" {
  type        = string
  description = "Github branch for source code"
  default     = "main"
}

variable "github_token" {
  type        = string
  description = "Github personal access token"
  sensitive   = true
}
variable "prefix" {
  type        = string
  description = "prefix for all resource names"
}