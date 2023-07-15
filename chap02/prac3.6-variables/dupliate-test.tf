locals {
  duplicate = "def"
}

variable "duplicate" {
  description = "A variable with a duplicated name"
  type        = string
}

data "aws_vpc" "duplicate" {
  default = true
}

resource "local_file" "duplicate" {
  filename = "${path.module}/duplicate.txt"
  content  = "asdf"
}

output "duplicate" {
  value = "${local.duplicate},${var.duplicate},${data.aws_vpc.duplicate.id},${local_file.duplicate.content}"
}
