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
  for_each = local.subnets
  vpc_id   = aws_vpc.grafana.id

  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  map_public_ip_on_launch = true

  tags = {
    Name = "sbn-${each.key}"
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
  for_each       = aws_subnet.pubsub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.route.id
}
