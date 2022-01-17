output "codebuild_project" {
  description = "AWS CodeBuild project"
  value       = aws_codebuild_project.main.name
}

output "iam_policy" {
  description = "Iam policy for CodeBuild"
  value       = aws_iam_role.main.arn
}

output "s3_bucket" {
  description = "S3 bucket for the CodeBuild project"
  value       = aws_s3_bucket.main.arn
}