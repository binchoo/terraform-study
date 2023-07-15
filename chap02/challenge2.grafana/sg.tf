resource "aws_security_group" "sg" {
  name        = "seg-demo-grafana"
  description = "seg-demo-grafana"
  vpc_id      = aws_vpc.grafana.id
}

resource "aws_security_group_rule" "ssh_rule" {
  type              = "ingress"
  description       = "SSH"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [local.instance_connect_ip]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "grafana_rule" {
  type              = "ingress"
  description       = "Grafana from MZC"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = [local.my_public_ip]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "outbound_rule" {
  type              = "egress"
  description       = "All traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}
