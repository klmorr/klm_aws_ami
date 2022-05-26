locals {
  Name = "win_2019"
  build_date = formatdate("MM-DD-YYYY", timestamp())
  ami_description = "base windows 2019 ami"
  common_tags = {
    builder = "packer"
    owner   = "klm"
    os  = "windows_2019"
  }
}

variable "filter_name" {
  type    = string
  default = "Windows_Server-2019-English-Full-Base-*"
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "owners" {
  type    = list(string)
  default = ["amazon"]
}

variable "region" {
  type    = string
  default = "${env("AWS_DEFAULT_REGION")}"
}

data "amazon-ami" "main" {
  filters = {
    name                = "${var.filter_name}"
    virtualization-type = "hvm"
    root-device-type    = "ebs"
  }
  most_recent = true
  owners      = "${var.owners}"
  region      = "${var.region}"
}

source "amazon-ebs" "main" {
  ami_description  = "${local.ami_description}"
  ami_name         = "${local.Name}_${local.build_date}"
  encrypt_boot     = true
  ena_support      = true
  communicator     = "winrm"
  force_deregister = true
  instance_type    = "${var.instance_type}"
  region           = "${var.region}"
  source_ami       = "${data.amazon-ami.main.id}"
  tags = "${merge(
    local.common_tags,
    {
      Name = "${local.Name}-${local.build_date}"
    }
  )}"
  user_data_file = "./scripts/windows/userdata.txt"
  winrm_insecure = true
  winrm_port     = 5986
  winrm_timeout  = "30m"
  winrm_use_ssl  = true
  winrm_username = "Administrator"
}

build {
  sources = ["source.amazon-ebs.main"]

  provisioner "powershell" {
    script = "./scripts/windows/Invoke-Provisioners.ps1"
  }

  post-processor "manifest" {
    output     = "${local.Name}_manifest.json"
    strip_path = true
  }
}
