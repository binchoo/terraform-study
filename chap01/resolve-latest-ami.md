# 최신 AMI ID 취득법

## 1. AWS SSM

### AWS CLI

**amazon-linux2**

```bash
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2
```

### Terraform [datasource ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/3.28.0/docs/data-sources/ssm_parameter)

**amazon-linux2**

```json
# AMI 취득법 1
data "aws_ssm_parameter" "amzn2_latest" {
    name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2"
}

resource "aws_instance" "example" {
    ami = data.aws_ssm_parameter.amzn2_latest.value
    instance_type = "t2.micro"
    tags = {
        Name = "t101-study"
    }
}
```

## 2. AWS EC2 AMI

## AWS CLI

```bash
aws ec2 describe-images --owners self amazon --filter 'Name=name,Values=amzn2-ami-hvm*' --query 'sort_by(Images, &CreationDate)[-1:].Name'
```

```bash
aws ec2 describe-images --owners self amazon --filter 'Name=name,Values=amzn2-ami-hvm*' --query 'sort_by(Images, &CreationDate)[-1:].ImageId'
```

### Terrform [datasource aws_ami](https://registry.terraform.io/providers/hashicorp/aws/3.54.0/docs/data-sources/ami)

**amazon-linux2**

```json
data "aws_ami" "linux" {
    owners = ["amazon"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-hvm*"]
    }
}

resource "aws_instance" "example" {
    ami = data.aws_ami.linux.id
    instance_type = "t2.micro"
    tags = {
        Name = "t101-study"
    }
}
```
