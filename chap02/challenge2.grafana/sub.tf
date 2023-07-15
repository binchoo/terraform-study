variable "instance_type" {
  description = "Grafana EC2 instance type."
  type        = string

  validation {
    condition     = can(regex("^[t|m].+\\.(\\bmicro\\b|\\bsmall\\b|\\bmedium\\b|\\blarge\\b)$", var.instance_type))
    error_message = "Available families are t or m, and sizes are micro, small, medium or large."
  }
}

data "aws_region" "current" {}

data "aws_ec2_instance_type_offerings" "azs" {
  location_type = "availability-zone"
  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }
}

data "aws_ami" "latest_amzn2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "local_file" "userdata" {
  filename = "${path.module}/userdata.sh"
}

data "http" "public_ip" {
  url = "http://icanhazip.com"
}

data "http" "instance_connect_ip_ranges" {
  url = "https://raw.githubusercontent.com/joetek/aws-ip-ranges-json/master/ip-ranges-ec2-instance-connect.json"
}

data "jq_query" "instance_connect_regional_ip_range" {
  data  = data.http.instance_connect_ip_ranges.response_body
  query = ".prefixes[] | select(.region==\"${data.aws_region.current.name}\")  | .ip_prefix"
}

locals {
  subnets = {
    for i, az in data.aws_ec2_instance_type_offerings.azs.locations : "pubsub_${i}" => {
      az   = az
      cidr = "10.254.${i}.0/24"
    }
  }

  lastest_amazon_linux2 = data.aws_ami.latest_amzn2.id
  userdata_content      = data.local_file.userdata.content

  my_public_ip        = "${chomp(data.http.public_ip.response_body)}/32"
  instance_connect_ip = trim(data.jq_query.instance_connect_regional_ip_range.result, "\"")
}

output "subnets" {
  value = local.subnets
}

output "userdata" {
  value = data.local_file.userdata.content
}