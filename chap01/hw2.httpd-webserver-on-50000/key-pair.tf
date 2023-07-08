data "local_file" "public_key" {
  filename = "my-key.pem.pub"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "kepr-webserver"
  public_key = data.local_file.public_key.content
}
