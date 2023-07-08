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
- AWS EC2 인스턴스에게는 Public Key를 보관시키면 된다. 인스턴스 리소스를 명세하는 과정에서 `key-name`을 지정해야 한다.

## Terraform [resource aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/3.9.0/docs/resources/key_pair)

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

-  `aws_key_pair` 리소스를 만들어 준다. `public_key` 속성에 아까 발급한 Public Key 내용을 작성해야 한다.
- `aws_instance`의 `key_name` 에다가 키-페어 리소스의 참조를 넣어준다.

### Terraform [datasource local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file.html#schema)

- 로컬에 저장되어 있는 `my-key.pem.pub` 파일의 content를 읽어와서 Public Key 내용을 주입하였다.

  
