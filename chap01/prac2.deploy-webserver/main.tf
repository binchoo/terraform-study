provider "aws" {
    region = "ap-northeast-2"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"] # Canonical
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

variable "security_group_name" {
    description = "The name of security group for web server"
    type = string # 따옴표가 없네용
    default = "web-security"
}

resource "aws_instance" "webserver" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.web_security.id]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, T101 Study" > index.html
                nohup busybox httpd -f -p 9090 &
                EOF
    user_data_replace_on_change = true
    tags = {
        Name = "terraform-study-101"
    }
}

resource "aws_security_group" "web_security" {
    name = var.security_group_name
    ingress {
        from_port = 9090
        to_port = 9090
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "public_ip" {
    description = "The public IP address of web server"
    value = aws_instance.webserver.public_ip
}
