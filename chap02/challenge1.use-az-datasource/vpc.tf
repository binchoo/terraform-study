data "aws_ec2_instance_type_offerings" "t2micro" {
  location_type = "availability-zone"
  filter {
    name   = "instance-type"
    values = ["t2.micro"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_subnet" "primary" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = data.aws_ec2_instance_type_offerings.t2micro.locations[0]
  cidr_block        = "172.31.200.0/28"
}

resource "aws_subnet" "secondary" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = data.aws_ec2_instance_type_offerings.t2micro.locations[1]
  cidr_block        = "172.31.201.0/28"
}
