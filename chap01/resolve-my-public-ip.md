# 나의 Public IP 취득법

## curl

```bash
curl icanhazip.com
```

## Terraform [datasource http](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http)

```json
data "http" "my_public_ip" {
  url = "http://icanhazip.com"
}

resource "aws_security_group" "ssh_security" {
  name        = "ssh-security"
  description = "Allow 22 inbound"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s%s", chomp(data.http.my_public_ip.response_body), "/32")]
  }
}
```

- `respone_body` 속성을 참조하면 나의 공개 IP를 획득할 수 있었다.
- 다만,`icanhazip.com` 요청 결과에는 `\n` 가 붙어 있어, 깔끔히 제거하기 위해서 HCL [`chomp()`](https://developer.hashicorp.com/terraform/language/functions/chomp) 적용.
- `/32`의 CIDR 프리픽스 붙여주기 위해 HCL [`format()`](https://developer.hashicorp.com/terraform/language/functions/format) 함수 사용.