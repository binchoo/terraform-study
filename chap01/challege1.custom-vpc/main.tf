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

resource "aws_instance" "webserver" {
  subnet_id = aws_subnet.public_subnet.id

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name      = aws_key_pair.key_pair.key_name

  vpc_security_group_ids = [
    aws_security_group.web_security.id,
    aws_security_group.ssh_security.id
  ]

  user_data_replace_on_change = true
  user_data = <<-EOF
                #!/bin/bash
                apt update -y
                apt install apache2 -y
                echo "Hello, T101 Study" > /var/www/html/index.html
                sed -i '0,/Listen [0-9]*/s//Listen ${var.server_port}/' /etc/apache2/ports.conf
                systemctl restart apache2
                systemctl enable apache2
                EOF

  tags = {
    Name = "terraform-study-101"
  }
}

resource "aws_security_group" "web_security" {
  name        = "web-security"
  description = "Allow 80 inbound"
  vpc_id = aws_vpc.custom_vpc.id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
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
  vpc_id = aws_vpc.custom_vpc.id

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [local.my_public_ip]
  }

  tags = {
    Name = "ssh-security"
  }

  depends_on = [ aws_route_table_association.public_subnet_association ]
}

output "public_ip" {
  description = "The public IP address of web server"
  value       = aws_instance.webserver.public_ip
}
