resource "aws_instance" "grafana" {
  depends_on = [aws_internet_gateway.igw]

  subnet_id     = aws_subnet.pubsub["pubsub_0"].id
  ami           = local.lastest_amazon_linux2
  instance_type = var.instance_type

  vpc_security_group_ids      = [aws_security_group.sg.id]
  user_data                   = local.userdata_content
  user_data_replace_on_change = true

  tags = {
    Name = "ec2-demo-grafana"
  }
}

output "public_ip" {
  value = format("http://%s:3000", aws_instance.grafana.public_ip)
}
