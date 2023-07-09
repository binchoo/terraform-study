# 최신 AMI ID 취득법


EC2 AMI의 최신 이미지를 알아내고자 할 때 이용해 볼만한 2가지 서비스를 정리했습니다. AWS CLI를 사용하거나 Terraform datasource를 이용해서 추상화된 방식으로 최신 AMI ID를 취득하여 봅시다.

- AWS SSM 서비스
- AWS EC2 서비스


## 참고 글

 - [Working with public parameters](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters.html)
  - [Query for the lastest Amazon Linux AMI IDs](https://aws.amazon.com/ko/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/)
  - [Query for the lastest Windows AMI IDs](https://aws.amazon.com/ko/blogs/mt/query-for-the-latest-windows-ami-using-systems-manager-parameter-store/)  
  - [Terraform datasource aws_ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/3.28.0/docs/data-sources/ssm_parameter)
  - [Terraform datasource aws_ami](https://registry.terraform.io/providers/hashicorp/aws/3.54.0/docs/data-sources/ami)
 - [JMESPath sort_by() 함수](https://jmespath.org/examples.html#sort-by)

## 1. AWS SSM


AWS System Manager의 파라미터 스토어에는 AWS가 관리하는 퍼블릭 파라미터가 존재합니다. 이곳에는 윈도 및 리눅스 운영체제의 EC2 최신 AMI 정보들을 조회할 수 있습니다. 관련 파라미터 이름들을 다 조회해 보기 위하여 `aws ssm get-parameters-by-path` CLI를 이용해 봅시다.

<details><summary><b>아마존 리눅스 최신 AMI SSM 파라미터</b></summary>

```bash
aws ssm get-parameters-by-path --path "/aws/service/ami-amazon-linux-latest" --query "Parameters[].Name" --output json --region ap-northeast-2
```

```json
[
    "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64",
    "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64",
    "/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-6.1-arm64",
    "/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-6.1-x86_64",
    "/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-default-arm64",
    "/aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-gp2",
    "/aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-s3",
    "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-ebs",
    "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2",
    "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-ebs",
    "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64",
    "/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-default-x86_64",
    "/aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-ebs",
    "/aws/service/ami-amazon-linux-latest/amzn-ami-minimal-hvm-x86_64-s3",
    "/aws/service/ami-amazon-linux-latest/amzn-ami-minimal-pv-x86_64-s3",
    "/aws/service/ami-amazon-linux-latest/amzn-ami-pv-x86_64-s3",
    "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-arm64-gp2",
    "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-arm64-gp2",
    "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2",
    "/aws/service/ami-amazon-linux-latest/amzn2-ami-minimal-hvm-arm64-ebs",
    "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64",
    "/aws/service/ami-amazon-linux-latest/amzn-ami-minimal-hvm-x86_64-ebs",
    "/aws/service/ami-amazon-linux-latest/amzn-ami-minimal-pv-x86_64-ebs",
    "/aws/service/ami-amazon-linux-latest/amzn-ami-pv-x86_64-ebs",
    "/aws/service/ami-amazon-linux-latest/amzn2-ami-minimal-hvm-x86_64-ebs"
]
```
</details>

<details><summary><b>윈도 최신 AMI SSM 파라미터</b></summary>

```bash
aws ssm get-parameters-by-path --path "/aws/service/ami-windows-latest" --query "Parameters[].Name" --output json --region ap-northeast-2
```

```json
[
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Chinese_Simplified-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Dutch-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Japanese-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Japanese-64Bit-SQL_2016_SP3_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Core-Containers",
    "/aws/service/ami-windows-latest/Windows_Server-2016-German-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Japanese-Full-SQL_2017_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Core-EKS_Optimized-1.25",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Japanese-Full-SQL_2019_Enterprise",
    "/aws/service/ami-windows-latest/amzn2-ami-hvm-2.0.20191217.0-x86_64-gp2-mono",
    "/aws/service/ami-windows-latest/EC2LaunchV2-Windows_Server-2016-English-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Chinese_Traditional-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Hungarian-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Italian-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2014_SP3_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Japanese-Full-SQL_2016_SP3_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Italian-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Japanese-Full-SQL_2017_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Italian-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Portuguese_Brazil-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Deep-Learning",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Japanese-Full-SQL_2016_SP3_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Korean-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Deep-Learning",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2017_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-STIG-Core",
    "/aws/service/ami-windows-latest/Windows_Server-2019-French-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Korean-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-SQL_2022_Web",
    "/aws/service/ami-windows-latest/amzn2-x86_64-SQL_2019_Express",
    "/aws/service/ami-windows-latest/EC2LaunchV2-Windows_Server-2016-English-Core-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2-English-STIG-Core",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-Containers",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2019_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2019_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Portuguese_Portugal-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Russian-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Core-EKS_Optimized-1.24",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Hungarian-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-ContainersLatest",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-French-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Core-SQL_2016_SP3_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2016_SP3_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Chinese_Simplified-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2016_SP3_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2019_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Core-EKS_Optimized-1.25",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-STIG-Core",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Japanese-Full-SQL_2022_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Russian-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-German-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Chinese_Traditional-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Hungarian-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Japanese-64Bit-SQL_2014_SP3_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Japanese-Full-SQL_2019_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Polish-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Core-EKS_Optimized-1.23",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Japanese-Full-SQL_2022_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-SQL_2019_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Polish-Full-Base",
    "/aws/service/ami-windows-latest/EC2LaunchV2-Windows_Server-2012_RTM-English-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-English-64Bit-SQL_2014_SP3_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-English-64Bit-SQL_2016_SP3_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Russian-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Chinese_Traditional_Hong_Kong_SAR-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Japanese-Full-SQL_2017_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-HyperV",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Japanese-Full-SQL_2019_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Core-Base",
    "/aws/service/ami-windows-latest/amzn2-ami-hvm-2.0.20180622.1-x86_64-gp2-dotnetcore",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-German-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Japanese-Full-SQL_2016_SP3_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Japanese-Full-SQL_2019_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-EKS_Optimized-1.26",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2016_SP3_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2022_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Japanese-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Japanese-Full-SQL_2022_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Russian-Full-Base",
    "/aws/service/ami-windows-latest/amzn2-x86_64-MATEDE_DOTNET",
    "/aws/service/ami-windows-latest/EC2LaunchV2-Windows_Server-2019-English-Full-Base",
    "/aws/service/ami-windows-latest/TPM-Windows_Server-2019-English-Full-SQL_2019_Standard",
    "/aws/service/ami-windows-latest/TPM-Windows_Server-2022-English-Full-SQL_2022_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-English-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Core-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Core-ContainersLatest",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2017_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-EKS_Optimized-1.27",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Hungarian-Full-Base",
    "/aws/service/ami-windows-latest/amzn2-ami-hvm-2.0.20190823-x86_64-gp2-mono",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2-English-STIG-Full",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-French-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Italian-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Polish-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-English-64Bit-SQL_2014_SP3_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-HyperV",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Chinese_Traditional-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2022_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-SQL_2017_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-STIG-Full",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-English-64Bit-SQL_2016_SP3_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Portuguese_Brazil-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Portuguese_Portugal-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Core-ContainersLatest",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Spanish-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-EKS_Optimized-1.25",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2017_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Turkish-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-German-Full-Base",
    "/aws/service/ami-windows-latest/amzn2-x86_64-SQL_2019_Enterprise",
    "/aws/service/ami-windows-latest/EC2LaunchV2-Windows_Server-2019-English-Core-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-English-64Bit-SQL_2014_SP3_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Swedish-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Italian-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2016_SP3_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2019_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Core-EKS_Optimized-1.26",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-EKS_Optimized-1.24",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-SQL_2019_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Japanese-Full-SQL_2017_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Czech-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-ECS_Optimized",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-STIG-Full",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Portuguese_Brazil-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Swedish-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Turkish-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Core-ECS_Optimized",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Core-ContainersLatest",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-SQL_2022_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-ContainersLatest",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2019_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Hungarian-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Japanese-Full-SQL_2017_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Core-EKS_Optimized-1.22",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2016_SP3_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Spanish-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Core-EKS_Optimized-1.27",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-SQL_2017_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Japanese-Full-Base",
    "/aws/service/ami-windows-latest/TPM-Windows_Server-2022-English-Full-SQL_2022_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-English-64Bit-SQL_2016_SP3_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Czech-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Turkish-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Dutch-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2017_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Japanese-Full-SQL_2022_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-EKS_Optimized-1.25",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Japanese-Full-SQL_2017_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Korean-Full-Base",
    "/aws/service/ami-windows-latest/TPM-Windows_Server-2016-English-Core-Base",
    "/aws/service/ami-windows-latest/TPM-Windows_Server-2016-English-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Japanese-64Bit-SQL_2014_SP3_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Core-SQL_2016_SP3_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2016_SP3_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-ContainersLatest",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2017_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Japanese-Full-SQL_2017_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Japanese-Full-SQL_2019_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Spanish-Full-Base",
    "/aws/service/ami-windows-latest/TPM-Windows_Server-2019-English-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-English-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Japanese-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Portuguese_Brazil-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Core-SQL_2016_SP3_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Chinese_Simplified-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Core-ECS_Optimized",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-SQL_2017_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-SQL_2019_Web",
    "/aws/service/ami-windows-latest/amzn2-x86_64-SQL_2019_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Chinese_Traditional_Hong_Kong-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-English-64Bit-SQL_2014_SP3_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Chinese_Simplified-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Japanese-64Bit-SQL_2014_SP3_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Core-EKS_Optimized-1.26",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-EKS_Optimized-1.23",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-EKS_Optimized-1.27",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2019_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-EKS_Optimized-1.23",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Japanese-Full-SQL_2022_Web",
    "/aws/service/ami-windows-latest/EC2LaunchV2-Windows_Server-2012_R2_RTM-English-Full-Base",
    "/aws/service/ami-windows-latest/TPM-Windows_Server-2019-English-Core-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-English-64Bit-Core",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Swedish-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2016_SP3_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-STIG-Core",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Japanese-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Japanese-Full-SQL_2017_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Chinese_Traditional-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-French-Full-Base",
    "/aws/service/ami-windows-latest/TPM-Windows_Server-2019-English-Full-SQL_2019_Enterprise",
    "/aws/service/ami-windows-latest/TPM-Windows_Server-2022-English-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-English-64Bit-SQL_2014_SP3_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-English-64Bit-SQL_2014_SP3_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Chinese_Simplified-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2016_SP3_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2022_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-STIG-Full",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-SQL_2019_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Japanese-Full-SQL_2017_Standard",
    "/aws/service/ami-windows-latest/TPM-Windows_Server-2022-English-Core-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-English-64Bit-SQL_2014_SP3_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2017_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Core-EKS_Optimized-1.27",
    "/aws/service/ami-windows-latest/Windows_Server-2019-German-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Polish-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Japanese-Full-SQL_2022_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Turkish-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Japanese-64Bit-SQL_2016_SP3_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Core-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2019_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2016-French-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Czech-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-EKS_Optimized-1.24",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-EKS_Optimized-1.26",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Japanese-Full-SQL_2019_Web",
    "/aws/service/ami-windows-latest/amzn2-ami-hvm-2.0.20190618-x86_64-gp2-mono",
    "/aws/service/ami-windows-latest/amzn2-x86_64-SQL_2019_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Turkish-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Polish-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Portuguese_Portugal-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Spanish-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Czech-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Core-SQL_2016_SP3_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Tesla",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-SQL_2017_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-SQL_2022_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Portuguese_Portugal-Full-Base",
    "/aws/service/ami-windows-latest/EC2LaunchV2-Windows_Server-2019-English-Full-ContainersLatest",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-English-64Bit-SQL_2016_SP3_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Japanese-64Bit-SQL_2016_SP3_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Korean-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Japanese-Full-SQL_2016_SP3_Enterprise",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Korean-Full-SQL_2016_SP3_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Dutch-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Japanese-Full-SQL_2019_Web",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Portuguese_Brazil-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Czech-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Japanese-64Bit-SQL_2014_SP3_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Dutch-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Japanese-64Bit-SQL_2014_SP3_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2017_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Tesla",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-EKS_Optimized-1.22",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2019_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Portuguese_Portugal-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Core-EKS_Optimized-1.23",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-ECS_Optimized",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Japanese-64Bit-SQL_2016_SP3_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-Spanish-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2014_SP3_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Japanese-Full-SQL_2019_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-ECS_Optimized",
    "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-SQL_2022_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Japanese-Full-SQL_2019_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2019-Swedish-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Dutch-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Core-EKS_Optimized-1.24",
    "/aws/service/ami-windows-latest/Windows_Server-2012-R2_RTM-English-64Bit-HyperV",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Korean-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2012-RTM-Russian-64Bit-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-Chinese_Traditional-Full-Base",
    "/aws/service/ami-windows-latest/Windows_Server-2016-English-Full-SQL_2017_Express",
    "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-SQL_2022_Standard",
    "/aws/service/ami-windows-latest/Windows_Server-2022-Swedish-Full-Base"
]
```
</details>

### AWS CLI


이제 AWS SSM 서비스를 CLI로 호출하여 최신 이미지 하나만 얻어오도록 하겠습니다. 

방금 전 모든 파라미터를 얻어올 때는 **경로 기반**으로 조회를 했는데요, 딱 하나만 참조하고픈 파라미터가 있을 경우엔 **이름 기반**으로 조회해 봅시다. 

이번에 참조할 파라미터는 아마존 리눅스2 `amzn2-ami-kernel-5.10-hvm-x86_64-gp2` AMI 입니다.

**amzn2-ami-kernel-5.10-hvm-x86_64-gp2 조회**

```bash
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2
```

```json
{
    "Parameters": [
        {
            "Name": "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2",
            "Type": "String",
            "Value": "ami-0ea4d4b8dc1e46212",
            "Version": 42,
            "LastModifiedDate": "2023-06-30T05:45:16.452000+09:00",
            "ARN": "arn:aws:ssm:ap-northeast-2::parameter/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2",
            "DataType": "text"
        }
    ],
    "InvalidParameters": []
}
```

### Terraform [datasource ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/3.28.0/docs/data-sources/ssm_parameter)


이번에는 테라폼 HCL을 이용해 추상화된 방식으로 SSM 서비스를 사용하겠습니다.

방금처럼 `amzn2-ami-kernel-5.10-hvm-x86_64-gp2`를 조회하기 위해 `ssm_parameter` 데이터소스를 참조하는 HCL 코드를 작성합니다.

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


AWS EC2 서비스를 통해 AMI 이미지들을 조회하고, 최신 이미지만 골라내는 방식을 더 알아봅니다.

## AWS CLI

`ec2 describe-images`를 호출하며 이미지 항목을 `CreationDate` 속성으로 정렬한 뒤 제일 마지막 항목을 취하면, 최근 AMI 이미지를 알아낼 수 있습니다.


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

비슷한 방식으로 HCL의 `aws_ami` 데이터소스를 선언하여 `most_recent` 속성을 **참**으로 두면, 더 편리하게 최신 AMI ID를 알아낼 수 있습니다.

**amzn2-ami-kernel-5.10-hvm-x86_64-gp2 조회**

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

- 마찬가지로 [`ami-0314c6b4d666713d7`](https://ap-northeast-2.console.aws.amazon.com/ec2/home?region=ap-northeast-2#ImageDetails:imageId=ami-0314c6b4d666713d7) 가 출력됩니다.
- 테라폼이나 AWS CLI 모두 동일한 AMI ID를 최신 amazon-linux2 이미지로 가져왔네요. (크로스 체크 완료)

어찌보면 테라폼에서 "datasource"를 사용한다는 것은 AWS CLI의 `descibe-*` 내지 `get-*` 호출을 추상화해서 쓰겠다는 의미 같습니다. 
