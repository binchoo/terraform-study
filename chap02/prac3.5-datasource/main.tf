data "local_file" "abc" {
    filename = "${path.module}/abc.txt"
}

data "aws_availability_zones" "available" {
    state = "available"
}

data "aws_vpc" "default" {
  default = true
} 

resource "aws_subnet" "primary" {
    vpc_id = data.aws_vpc.default.id
    availability_zone = data.aws_availability_zones.available.names[0]
    cidr_block = "172.31.200.0/28"
}

resource "aws_subnet" "secondary" {
    vpc_id = data.aws_vpc.default.id
    availability_zone = data.aws_availability_zones.available.names[1]
    cidr_block = "172.31.201.0/28"
}
