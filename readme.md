# codebuild ami creator

## Description

Codebuild project for creating ami images using packer

### Terraform Project Templates

| Name | Description |
|------|-------------|
| [codebuild-ami-packer](src/terraform/codebuild-ami-packer/readme.md) | Terraform template for creating a codebuild project to build amis |
| [codebuild-token-github](src/terraform/codebuild-token-github/readme.md) | Adds Github personal access token to codebuild (Only run if token has not been previously added) |

### Packer Templates

| Name | Description |
|------|-------------|
| [amazon_linux2](src/pkr/amazon_linux_2.json) | Packer template to create an Amazon Linux 2 ami |
| [windows_2016](src/pkr/windows_2016,json) | Packer template to create a Windows 2016 base ami |
| [windows_2019](src/pkr/windows_2019.json) | Packer template to create a Windows 2019 base ami |

#### Getting started

Adding GitHub personal access token. This process only needs to run if Github credentials have not been previously configured in AWS

See [Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) for instructions on creating a personal access token in Github

Clone this repo

```bash
git clone https://github.com/klmorr/klm_aws_ami.git
```

#### Adding personal access token to AWS

[Skip to Create CodeBuild Project](#create-codebuild-project) if Github credentials have already been added to AWS

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

#### Running the Codebuild project

1. [Log into the AWS Management Console](https://console.aws.amazon.com)

2. Navigate to CodeBuild

3. Click the CodeBuild project

4. Click **Start Build**

By default this will build the amazon linux 2 ami. To build another available OS, select **Start Build With Overrides**, type the value in the Environment Varibles section for OS. The value will need to match the base name of the packer template. Example to build **windows_2016.json**, use **windows_2016**

Available OS builds

- amazon_linux_2
- windows_2016
- windows_2016