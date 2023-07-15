variable "prefix" {
  default = "hello"
}

# locals {
#   content = "content2" # 중복 선언되었으므로 오류가 발생한다.
# }

resource "local_file" "abc" {
  content  = local.content
  filename = "${path.module}/abc.txt"
}