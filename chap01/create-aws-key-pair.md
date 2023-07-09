# AWS Key-Pair 만드는 법

EC2 인스턴스가 SSH 유저를 인증할 때 키 파일을 사용할 수 있습니다.
  - SSH 유저는 **프라이빗 키**를 제시합니다.
  - SSH 서버(EC2)는 보유하고 있는 **퍼블릭 키**로 프라이빗 키의 유효성을 검증합니다.

우리가 직접 EC2 인스턴스 내부에 퍼블릭 키를 배치할 필요까지는 없습니다. EC2 KeyPair 자원을 정의하고 설정해 주면 되기 때문이죠.

## SSH-Keygen

실습으로 사용할 퍼블릭, 프라이빗 키를 발급하기 위해 `ssh-keygen` 명령을 수행합시다.

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

**실행 결과**
- 퍼블릭 키: `mykey.pem.pub`
- 프라이빗 키: `mykey.pem`

이제 AWS EC2 인스턴스에게 `mykey.pem.pub`를 보관시키면 됩니다. 

EC2 KeyPair 자원으로서 퍼블릭 키를 AWS로 Import 한 다음, 해당 KeyPair를 참조하는 EC2 인스턴스를 생성하면 됩니다.

## Terraform [resource aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/3.9.0/docs/resources/key_pair)

테라폼을 통해 퍼블릭 키를 EC2 키페어로 Import 할 때는 해당 퍼블릭 키 문자열을 전달해야 합니다. `mykey.pem.pub` 내부의 문자열이 꽤 길 수 있기에 로컬 파일의 컨텐츠 자체를 읽어오는 방식을 채택했습니다.

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

1. `aws_key_pair` 리소스를 만들어 준다. `public_key` 속성에 아까 발급한 퍼블릭 키 내용을 작성해야 한다.
2. `local_file` 데이터소스를 사용하여 `my-key.pem.pub` 파일의 content를 읽고 Public Key 내용으로 주입할 수 있다.
3. `aws_instance`의 `key_name` 에다가 키페어 리소스의 참조를 넣어준다.

> Terraform [datasource local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file.html#schema)
  