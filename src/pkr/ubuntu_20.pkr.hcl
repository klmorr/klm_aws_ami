locals {
  Name = "ubuntu_20"
  build_date = formatdate("MM-DD-YYYY", timestamp())
  ami_description = "base ubuntu 20 ami"
  common_tags = {
    builder = "packer"
    owner   = "kmo"
    os  = "ubuntu_20"
  }
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "owners" {
  type    = list(string)
  default = ["099720109477"]
}

variable "region" {
  type    = string
  default = "${env("AWS_DEFAULT_REGION")}"
}

variable "source_ami" {
  type    = string
  default = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

data "amazon-ami" "main" {
  filters = {
    architecture                       = "x86_64"
    name                               = "${var.source_ami}"
    root-device-type                   = "ebs"
    virtualization-type                = "hvm"
  }
  most_recent = true
  owners      = var.owners
  region      = "${var.region}"
}

source "amazon-ebs" "main" {
  ami_description  = local.ami_description
  ami_name         = "${local.Name}_${local.build_date}"
  force_deregister = true
  instance_type    = "${var.instance_type}"
  region           = "${var.region}"
  source_ami       = "${data.amazon-ami.main.id}"
  ssh_username     = "${var.ssh_username}"
  tags = "${merge(
    local.common_tags,
    {
      Name = "${local.Name}-${local.build_date}"
    }
  )}"
}

build {
  sources = ["source.amazon-ebs.main"]

  provisioner "shell" {
    script = "./scripts/linux/provisioner.sh"
  }

  post-processor "manifest" {
    output     = "${local.Name}_manifest.json"
    strip_path = true
  }
}
