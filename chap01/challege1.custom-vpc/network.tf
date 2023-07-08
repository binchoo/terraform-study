resource "aws_vpc" "custom_vpc" {
    cidr_block = var.vpc_cidr

    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "vpc-t101-study"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.custom_vpc.id
    
    tags = {
        Name = "igw-t101-study"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.custom_vpc.id
    availability_zone = "ap-northeast-2c"
    cidr_block = "${split("/", aws_vpc.custom_vpc.cidr_block)[0]}/24"

    map_public_ip_on_launch = true

    tags = {
        Name = "sbn-t101-study-pub"
    }
}

resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.custom_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "rt-t101-study-pub"
    }
}

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route.id
}
