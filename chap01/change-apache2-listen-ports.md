# Ubuntu Apache2 서버의 리슨 포트 변경하기

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

- 여기서 `80` 리슨 포트를 `50000`으로 바꾸기 위해 `sed` 명령을 활용해 보자.

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

```bash
sudo servicectl restart apahce2
```

포트 변경을 반영하기 위해 apche2 서비스를 재시작 한다.
