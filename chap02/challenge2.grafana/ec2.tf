data "aws_ami" "latest_amzn2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "local_file" "userdata_file" {
  filename = "${path.module}/userdata.sh"
}

resource "aws_instance" "grafana_ec2" {
  depends_on = [aws_internet_gateway.igw]

  subnet_id     = aws_subnet.pubsub.id
  ami           = data.aws_ami.latest_amzn2.id
  instance_type = "t3.large"

  vpc_security_group_ids      = [aws_security_group.sg.id]
  user_data                   = data.local_file.userdata_file.content
  user_data_replace_on_change = true

  tags = {
    Name = "ec2-demo-grafana"
  }
}

output "public_ip" {
  value = format("http://%s:3000", aws_instance.grafana_ec2.public_ip)
}

output "userdata" {
  value = data.local_file.userdata_file.content
}
