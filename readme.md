# codebuild ami creator

## Description

Codebuild project for creating ami images using packer

### Terraform Project Templates

| Name | Description |
|------|-------------|
| [codebuild-ami-packer](/terraform/codebuild-ami-packer/readme.md) | Terraform template for creating the codebuild project |
| [codebuild-token-github](/terraform/codebuild-token-github/readme.md) | Adds Github personal access token to codebuild (Only run if token has not been previously added) |

### Packer Templates

| Name | Description |
|------|-------------|
| [amazon_linux2](pkr/amazon_linux2.json) | Packer template to create an Amazon Linux 2 ami |
| [kali_linux](pkr/kali_linux.json) | Packer template to create a Kali Linux ami, must subscribe to ami in AWS Marketplace |
| [windows_2016](pkr/vars/windows_2016_vars.json) | Packer template to create a Windows 2016 base ami |
| [windows_2019] | Packer template to create a Windows 2019 base ami |

#### Getting started

Adding GitHub personal access token. This process only needs to run if Github credentials have not been previously configured in AWS

See [Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) for instructions on creating a personal access token in Github

Clone this repo

```bash
git clone https://github.com/klmorr/klm_aws_ami.git
```

#### Adding personal access token to AWS

Skip to [#Create CodeBuild Project] if Github credentials have already been added to AWS

1. Navigate to codebuild-token-github

```bash
cd ./terraform/codebuild-token-github
```

2. Rename terraform.tfvars.template to terraform.tfvars

Nix

```bash
mv terraform.tfvars.template terraform.tfvars
```

Windows

```powershell
Rename-Item -Path .\terraform.tfvars.template -NewName terraform.tfvars
```

3. Add values for variables in the terraform.tfvars file

example:

```bash
aws_profile  = "my-profile"
aws_region   = "us-east-1"
github_token = "***********"
```

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
```

6. Deploy the terrform configuration

```bash
terraform apply

#To skip the confirmation prompt

terraform apply -auto-approve
```

#### Create CodeBuild Project

1. Navigate to codebuild-ami-packer

```bash
cd ./terraform/codebuild-ami-packer
```

2. Rename terraform.tfvars.template to terraform.tfvars

Nix

```bash
mv terraform.tfvars.template terraform.tfvars
```

Windows

```powershell
Rename-Item -Path .\terraform.tfvars.template -NewName terraform.tfvars
```

3. Add values for variables in the terraform.tfvars file

example:

```bash
aws_profile     = "my-profile"
aws_region      = "us-east-1"
github_branch   = "main"
github_location = "https://github.com/klmorr/klm_aws_ami.git"
prefix          = "dev"
project_name    = "ami-builder"
s3_bucket_acl   = "private"
tags            = {
    owner = "me"
    env = "dev"
}
```

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
```

6. Deploy the terrform configuration

```bash
terraform apply

#To skip the confirmation prompt

terraform apply -auto-approve
```