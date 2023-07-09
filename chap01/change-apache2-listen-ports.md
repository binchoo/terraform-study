# Ubuntu Apache2 서버의 리슨 포트 변경하기

우분투에 띄운 apache2 (httpd) 서버가 듣고 있는 리슨 포트를 변경하기 위한 방안을 설명합니다.

## 포트 설정 위치

`/etc/apache2/ports.conf`

**기본 컨텐츠**

```apache
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 80

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>
```

- 기본적인 `80`, `443` 포트로 서버가 리슨하고 있습니다.
- `80` 포트를 `50000`으로 바꾸기 위해 `sed` 명령을 활용해 봅니다.

  ```bash
  sed -i '0,/Listen [0-9]*/s//Listen ${var.server_port}/' /etc/apache2/ports.conf
  ```

**변경 후 컨텐츠**

```apache
Listen 50000

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>
```

## Apache2 재시작

포트 변경을 반영하기 위해 apche2 서비스를 재시작 합니다.

```bash
sudo systemctl restart apache2
```

## EC2 Userdata에 적용해 보기

apache2 서버의 포트 변경을 EC2 실행 초기에 적용할 수 있도록, EC2 Userdata에 알게 된 내용을 작성해 봅니다. 

```hcl
resource "aws_instance" "webserver" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  ...
  user_data = <<-EOF
                #!/bin/bash
                apt update -y
                apt install apache2 -y
                echo "Hello, T101 Study" > /var/www/html/index.html
                sed -i '0,/Listen [0-9]*/s//Listen ${var.server_port}/' /etc/apache2/ports.conf
                systemctl restart apache2
                systemctl enable apache2
                EOF
  ...
}
```
