provider "aws" {
  region = "ap-northeast-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "http" "my_public_ip" {
  url = "http://icanhazip.com"
}

data "local_file" "public_key" {
  filename = "my-key.pem.pub"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "kepr-webserver"
  public_key = data.local_file.public_key.content
}

resource "aws_instance" "webserver" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [
    aws_security_group.web_security.id,
    aws_security_group.ssh_security.id
  ]
  user_data = <<-EOF
                #!/bin/bash
                apt update -y
                apt install apache2 -y
                echo "Hello, T101 Study" > /var/www/html/index.html
                systemctl start apache2
                systemctl enable apache2
                EOF
  user_data_replace_on_change = true
  tags = {
    Name = "terraform-study-101"
  }
}

resource "aws_security_group" "web_security" {
  name        = "web-security"
  description = "Allow 80 inbound"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-security"
  }
}

resource "aws_security_group" "ssh_security" {
  name        = "ssh-security"
  description = "Allow 22 inbound"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s%s", chomp(data.http.my_public_ip.response_body), "/32")]
  }
}

output "public_ip" {
  description = "The public IP address of web server"
  value       = aws_instance.webserver.public_ip
}
