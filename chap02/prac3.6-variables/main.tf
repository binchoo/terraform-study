variable "my_var" {
  default = "var2"
}

resource "local_file" "abc" {
  content  = var.my_var
  filename = "${path.module}/abc.txt"
}
# variable "string" {
#   type        = string
#   description = "var string"
#   default     = "abc"
# }

# variable "number" {
#   type        = number
#   description = "var number"
#   default     = 123
# }

# variable "bool" {
#   type    = bool
#   default = true
# }

# variable "list" {
#   default = [
#     "google",
#     "vmware",
#     "azure",
#     "amazon"
#   ]
# }

# variable "object" {
#   type = object({
#     name = string
#     age  = number
#   })
#   default = {
#     name = "abc"
#     age  = 11
#   }
# }

# variable "tuple" {
#   type    = tuple([string, number, bool])
#   default = ["abc", 123, false]
# }

# output "list_index_0" {
#   value = var.list.0
# }

# output "list_all" {
#   value = [
#     for name in var.list : upper(name)
#   ]
# }
