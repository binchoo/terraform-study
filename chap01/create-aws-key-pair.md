# AWS Key-Pair 만드는 법

## SSH-Keygen

```bash
> ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/mzc01-jaebin.joo/.ssh/id_rsa): mykey.pem^ Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in mykey.peem
Your public key has been saved in mykey.peem.pub
The key fingerprint is:
SHA256:tnkQJuPPGligb6k5NY9j3fwLotA1Hgi+JNf2+8fU0/k mzc01-jaebin.joo@MZC01-JAEBINJOO.local
The key's randomart image is:
+---[RSA 3072]----+
|                 |
|                 |
|  . . o o        |
| . + + + .       |
|. = + * S  . . . |
| + =oB * +. o o  |
|  o.*==o*o.  . . |
|  .=+.o=ooo     E|
|  oo..o..oo.     |
+----[SHA256]-----+
```

- `ssh-keygen`  수행하여 Public Key와 Private Key를 발급한다.
  - 퍼블릭 키: `mykey.pem.pub`
  - 프라이빗 키: `mykey.pem`
- AWS EC2 인스턴스에게는 `mykey.pem.pub`를 보관시키면 된다. 그 이전에 AWS에 해당 파일을 EC2 키-페어 자원으로 Import 시켜야 한다.

## Terraform [resource aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/3.9.0/docs/resources/key_pair)

테라폼에서 EC2 키-페어 자원을 생성할 때는 퍼블릭 키 문자열을 전달해야 한다. `mykey.pem.pub` 내부의 문자열이 꽤 길 수 있기에, 로컬 파일의 컨텐츠 자체를 읽어오는 방식을 채택했다.

```hcl
data "local_file" "public_key" {
  filename = "my-key.pem.pub"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "kepr-webserver"
  public_key = data.local_file.public_key.content
}

resource "aws_instance" "webserver" {
  ...
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name
  ...
}
```

- `aws_key_pair` 리소스를 만들어 준다. `public_key` 속성에 아까 발급한 Public Key 내용을 작성해야 한다.
- `aws_instance`의 `key_name` 에다가 키-페어 리소스의 참조를 넣어준다.

### Terraform [datasource local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file.html#schema)

- local_file 데이터소스를 사용하여 `my-key.pem.pub` 파일의 content를 읽고 Public Key 내용으로 주입하였다.

  
