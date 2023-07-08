provider "aws" {
    region = "ap-northeast-2"
}

# AMI 취득법 1
# data "aws_ssm_parameter" "amzn2_latest" {
#     name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2"
# }
# Then
# ami = data.aws_ssm_parameter.amzn2_latest.value

# AMI 취득법 2
data "aws_ami" "linux" {
    owners = ["amazon"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-hvm*"]
    }
}
# Then,
# ami = data.aws_ami.linux.id

resource "aws_instance" "example" {
    ami = data.aws_ami.linux.id
    instance_type = "t2.micro"
    tags = {
        Name = "t101-study"
    }
}
