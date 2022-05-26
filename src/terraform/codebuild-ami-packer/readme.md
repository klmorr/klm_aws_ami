<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.15.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.15.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.main](https://registry.terraform.io/providers/hashicorp/aws/4.15.1/docs/resources/codebuild_project) | resource |
| [aws_codebuild_source_credential.main](https://registry.terraform.io/providers/hashicorp/aws/4.15.1/docs/resources/codebuild_source_credential) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/4.15.1/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.main](https://registry.terraform.io/providers/hashicorp/aws/4.15.1/docs/resources/iam_role_policy) | resource |
| [aws_ssm_parameter.main](https://registry.terraform.io/providers/hashicorp/aws/4.15.1/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | Time in minutes forAWS CodeBuild to wait until timing out any related build that does not get marked as completed | `number` | `30` | no |
| <a name="input_github_branch"></a> [github\_branch](#input\_github\_branch) | Github branch for source code | `string` | `"main"` | no |
| <a name="input_github_location"></a> [github\_location](#input\_github\_location) | Github uri for source code | `string` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | Github personal access token | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | prefix for all resource names | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codebuild_project"></a> [codebuild\_project](#output\_codebuild\_project) | AWS CodeBuild project |
| <a name="output_iam_policy"></a> [iam\_policy](#output\_iam\_policy) | Iam policy for CodeBuild |
<!-- END_TF_DOCS -->