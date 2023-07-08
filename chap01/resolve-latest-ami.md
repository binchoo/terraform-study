# 최신 AMI ID 취득법

## 1. AWS SSM

### AWS CLI

**amazon-linux2**

```bash
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2
```

### Terraform [datasource ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/3.28.0/docs/data-sources/ssm_parameter)

**amazon-linux2**

```hcl
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

`ec2 descrobe-images`를 호출하면서 이미지 항목을 `CreationDate` 속성으로 정렬한 후 제일 마지막 항목을 취하면, 최근 AMI 이미지를 알아낼 수 있다.

```bash
aws ec2 describe-images --owners self amazon --filter 'Name=name,Values=amzn2-ami-hvm*' --query 'sort_by(Images, &CreationDate)[-1:].Name'
```

```bash
aws ec2 describe-images --owners self amazon --filter 'Name=name,Values=amzn2-ami-hvm*' --query 'sort_by(Images, &CreationDate)[-1:].ImageId'
```

**실행 결과**

![lastest-ami-by-cli](https://github.com/binchoo/terraform-study/assets/15683098/9cd8a36e-e3cc-4d4b-93f4-96f2f4bb41ee)

 - [`ami-0314c6b4d666713d7`](https://ap-northeast-2.console.aws.amazon.com/ec2/home?region=ap-northeast-2#ImageDetails:imageId=ami-0314c6b4d666713d7) 가 출력된다.

### Terrform [datasource aws_ami](https://registry.terraform.io/providers/hashicorp/aws/3.54.0/docs/data-sources/ami)

**amazon-linux2**

```hcl
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

**실행 결과**

![latest-ami-by-terraform](https://github.com/binchoo/terraform-study/assets/15683098/f78c3ead-b722-4c35-8319-8ff1f8db3f53)

- 마찬가지로, [`ami-0314c6b4d666713d7`](https://ap-northeast-2.console.aws.amazon.com/ec2/home?region=ap-northeast-2#ImageDetails:imageId=ami-0314c6b4d666713d7) 가 출력된다.
- 테라폼과 AWS CLI를 모두 동일한 AMI ID를 최신 amazon-linux2 이미지로 가져왔다. 크로스 체크 완료.
