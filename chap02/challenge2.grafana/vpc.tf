resource "aws_vpc" "grafana" {
  cidr_block = "10.254.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-demo-grafana"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.grafana.id

  tags = {
    Name = "igw-demo-grafana"
  }
}

resource "aws_subnet" "pubsub" {
  vpc_id     = aws_vpc.grafana.id
  cidr_block = "10.254.0.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name = "sbn-demo-grafana"
  }
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.grafana.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-demo-grafana"
  }
}

resource "aws_route_table_association" "route_asso" {
  subnet_id      = aws_subnet.pubsub.id
  route_table_id = aws_route_table.route.id
}
