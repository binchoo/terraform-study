variable "names" {
  type    = list(string)
  default = ["a", "b"]
}

output "A_upper_value" {
  value = [for v in var.names : upper(v)]
}

output "B_index_and_value" {
  value = [for i, v in var.names : "${i} is ${v}"]
}

output "C_make_object" {
  value = { for v in var.names : v => upper(v) }
}

output "D_with_filter" {
  value = [for v in var.names : upper(v) if v != "a"]
}

variable "members" {
  type = map(object({
    role = string
  }))
  default = {
    ab = { role = "member", group = "dev" }
    cd = { role = "admin", group = "dev" }
    ef = { role = "member", group = "ops" }
  }
}

output "A_to_tupple" {
  value = [for k, v in var.members : "${k} is ${v.role}"]
}

output "B_get_only_role" {
  value = {
    for name, user in var.members : name => user.role
    if user.role == "admin"
  }
}

output "C_group" {
  value = {
    for name, user in var.members : user.role => name... # member 키가 충돌 ... 붙이면 그룹화 가능
  }
}
