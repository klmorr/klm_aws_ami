output "codebuild_credential" {
  description = "Codebuild github credential"
  value       = aws_codebuild_source_credential.main.arn
}