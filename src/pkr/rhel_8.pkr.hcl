locals {
  Name = "rhel_8"
  build_date = formatdate("MM-DD-YYYY", timestamp())
  ami_description = "base red hat 8 ami"
  common_tags = {
    builder = "packer"
    owner   = "kmo"
    os  = "redhat_8"
  }
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "owners" {
  type    = list(string)
  default = ["309956199498"]
}

variable "region" {
  type    = string
  default = "${env("AWS_DEFAULT_REGION")}"
}

variable "source_ami" {
  type    = string
  default = "RHEL-8.5_HVM-*-x86_64-*-Hourly2-GP2"
}

variable "ssh_username" {
  type    = string
  default = "ec2-user"
}

data "amazon-ami" "main" {
  filters = {
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
