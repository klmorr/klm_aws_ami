# codebuild ami creator

## Description

[CodeBuild](https://aws.amazon.com/codebuild/) project for creating ami images using packer

Requirements

- [Terraform](https://www.terraform.io/)
- [Packer](https://www.packer.io/)

Useful tools

| Name | Description |
|------|-------------|
| [terraform-docs](https://github.com/terraform-docs/terraform-docs) | A utility to generate documentation from Terraform modules in various output formats |
| [tfsec](https://github.com/aquasecurity/tfsec) | tfsec uses static analysis of your terraform templates to spot potential security issues |

### Terraform Project Templates

| Name | Description |
|------|-------------|
| [codebuild-ami-packer](src/terraform/codebuild-ami-packer/readme.md) | Terraform template for creating a codebuild project to build amis |

### Packer Templates

| Name | Description |
|------|-------------|
| [amazon_2](src/pkr/amazon_2.pkr.hcl) | Packer template to create an Amazon Linux 2 ami |
| [ubuntu_22](src/pkr/ubuntu_22.pkr.hcl) | Packer template to create Ubuntu 22.04 ami |
| [rhel_8](src/pkr/rhel_8.pkr.hcl) | Packer template to create RedHat 8 ami |
| [windows_2016](src/pkr/windows_2019.pkr.hcl) | Packer template to create a Windows 2019 base ami |
| [windows_2019](src/pkr/windows_2022.pkr.hcl) | Packer template to create a Windows 2022 base ami |

#### Getting started

See [Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) for instructions on creating a personal access token in Github

Clone this repo

```bash
git clone https://github.com/klmorr/klm_aws_ami.git
```

#### Adding personal access token to AWS

[Skip to Create CodeBuild Project](#create-codebuild-project)

#### Create CodeBuild Project

Note: Terraform provider uses a partial s3 backend configuration. Values can either be hardcoded into the provider file, passed using TF_VAR environment variables, or a config file. ***S3 Bucket and DynamoDB table must exist**. If not using a backend, the **backend "s3" {} statement can be removed from the **provider.tf** file

examples:

harcoded

```terraform
backend "s3" {
    bucket = "s3 bucket name"
    key = "ami-builder/terraform.tfstate"
    region = "your aws region"
    encrypt = true
    dynamodb_table = "dynamodb_table"
}
```

envrionment variables

```bash
terraform init -backend-config="bucket=s3 bucket name" \
-backend-config="ami-builder/terraform.tfstate" \
-backend-config="region=your aws region" \
-backend-config="encrypt=true" \
-backend-config="dynamodb_table="your dynamodb table"
```

config file ex: config.s3.your-aws-region.tfbackend

```bash
terraform init -backend-config="confid.s3.us-east-1.tfbackend
```

1. Navigate to codebuild-ami-packer

```bash
cd ./terraform/codebuild-ami-packer
```

2. Create a terraform.tfvars file from the terraform.tfvars.template. If not using a tfvars file, you will be prompted to input values. If using terraform-docs, run the following to generate a tfvars file, then add desired values.

```bash
terraform-docs tfvars hcl ./ > tfvars.example
```

example:

```bash
aws_profile  = "my-profile"
aws_region   = "us-east-1"
github_token = "***********"
```

3. Add values for variables in the terraform.tfvars file

example:

```bash
build_timeout   = 30
github_branch   = "main"
github_location = "https://github.com/klmorr/klm_aws_ami.git"
github_token    = ""
prefix          = "me"
```

Note: Recommend to add the github_token value using [Terraform environment variables](https://www.terraform.io/language/values/variables)

4. Initiate the terraform project

```bash
terraform init
```

5. (Optional) Validate the terraform configuration
   
```bash
terraform valildate
```

5. Review the configuration

```bash
terraform plan


#If using environment variable got github token

terraform plan -var github_token=******
```

6. Deploy the terrform configuration

```bash
terraform apply

#To skip the confirmation prompt

terraform apply -auto-approve

#If using environment variable got github token

terraform apply -var github_token=******
```

#### Running the Codebuild project

**Console**

1. [Log into the AWS Management Console](https://console.aws.amazon.com)

2. Navigate to CodeBuild

3. Click the CodeBuild project

4. Click **Start Build**

By default this will build the amazon linux 2 ami. To build another available OS, select **Start Build With Overrides**, type the value in the Environment Varibles section for OS. The value will need to match the base name of the packer template. Example to build **windows 2022**, use **windows_2022**

Available OS builds

- Amazon Linux 2
- RedHat 8
- Ubuntu 22.04
- Windows 2019
- Windows 2022

**AWScli**

```bash
# default build (amazon_linux_2)
aws codebuild start-build --project-name <project-name> --profile <credential_profile>

# specify os
aws codebuild start-build --project-name <project-name> --environment-variables-override <os_name>
```