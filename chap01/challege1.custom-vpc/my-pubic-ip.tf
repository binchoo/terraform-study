data "http" "my_public_ip" {
  url = "http://icanhazip.com"
}

locals {
  my_public_ip = "${chomp(data.http.my_public_ip.response_body)}/32"
}
