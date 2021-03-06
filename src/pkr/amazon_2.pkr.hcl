locals {
  Name = "amazon_2"
  build_date = formatdate("MM-DD-YYYY", timestamp())
  ami_description = "base amazon linux 2 ami"
  common_tags = {
    builder = "packer"
    owner   = "kmo"
    os  = "amazon_linux_2"
  }
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "owners" {
  type    = list(string)
  default = ["amazon"]
}

variable "region" {
  type    = string
  default = "${env("AWS_DEFAULT_REGION")}"
}

variable "source_ami" {
  type    = string
  default = "*amzn2-ami-hvm-*"
}

variable "ssh_username" {
  type    = string
  default = "ec2-user"
}

data "amazon-ami" "main" {
  filters = {
    architecture                       = "x86_64"
    "block-device-mapping.volume-type" = "gp2"
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
