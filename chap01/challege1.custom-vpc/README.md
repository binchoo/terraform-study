# 챌린지1 수행 결과

**terraform plan**

```bash
❯ TF_VAR_server_port=8080 TF_VAR_vpc_cidr=10.10.0.0/16 terraform plan
data.http.my_public_ip: Reading...
data.local_file.public_key: Reading...
data.local_file.public_key: Read complete after 0s [id=cc7c98b240b5f5ce7bb185de372825c8016cae7d]
data.http.my_public_ip: Read complete after 0s [id=http://icanhazip.com]
data.aws_ami.ubuntu: Reading...
data.aws_ami.ubuntu: Read complete after 0s [id=ami-081463b77e865f4ae]

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.webserver will be created
  + resource "aws_instance" "webserver" {
      + ami                                  = "ami-081463b77e865f4ae"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "kepr-webserver"
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "terraform-study-101"
        }
      + tags_all                             = {
          + "Name" = "terraform-study-101"
        }
      + tenancy                              = (known after apply)
      + user_data                            = "369e7802a09c113349b8d525520a89fae1d72cf1"
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = true
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id                 = (known after apply)
              + capacity_reservation_resource_group_arn = (known after apply)
            }
        }

      + cpu_options {
          + amd_sev_snp      = (known after apply)
          + core_count       = (known after apply)
          + threads_per_core = (known after apply)
        }

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + enclave_options {
          + enabled = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + instance_market_options {
          + market_type = (known after apply)

          + spot_options {
              + instance_interruption_behavior = (known after apply)
              + max_price                      = (known after apply)
              + spot_instance_type             = (known after apply)
              + valid_until                    = (known after apply)
            }
        }

      + maintenance_options {
          + auto_recovery = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
          + instance_metadata_tags      = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_card_index    = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + private_dns_name_options {
          + enable_resource_name_dns_a_record    = (known after apply)
          + enable_resource_name_dns_aaaa_record = (known after apply)
          + hostname_type                        = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_internet_gateway.igw will be created
  + resource "aws_internet_gateway" "igw" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Name" = "igw-t101-study"
        }
      + tags_all = {
          + "Name" = "igw-t101-study"
        }
      + vpc_id   = (known after apply)
    }

  # aws_key_pair.key_pair will be created
  + resource "aws_key_pair" "key_pair" {
      + arn             = (known after apply)
      + fingerprint     = (known after apply)
      + id              = (known after apply)
      + key_name        = "kepr-webserver"
      + key_name_prefix = (known after apply)
      + key_pair_id     = (known after apply)
      + key_type        = (known after apply)
      + public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC78WeN9HQvnVUarQTnQKhnT7PsWkW3uUw/qIqdmUKA4a1awYUuB6czC5do9bCejwnXUhKqUcvDEa36KxhRtdriDzdgVzOAUx1GZbyg/uSROveTXL7vO8vU1EDmOx8DOKEoYpGx2XfITvuzIVc6QbDi0D4Ameu6I+atah/AypPOB3IcdDayBGI6Y/eJi5OVmuLz0Hu9u4u8v7NNsKKRKvj2GA8zoy1QC/8NN3Q2BWLCEX71Crb42tf/8hsyWj/x9AgfKoLhxyEgHebLha2GO76g4+3WvvsSIYMwnETCUI/+sKE1305cpGY67tSVo3fGjPW50BQUrUzNYVjRA3mHyFKZ7bJ9XhuXACI4QjOpHAyZiVtUuCKodTUuY/fLUWuiNKr7cYazvdpEgOXt8uGvJKRRR3xlupdVFEpeFp5q6aQDE+sFtN7pIo+oyI84vXAaOC0iXoYUUIaa8uLdZkhlwfAJkk03sqXlJ9tBeyTUQPdl436AoWlINy4PDUz3dMQoEYM= mzc01-jaebin.joo@MZC01-JAEBINJOO.local"
      + tags_all        = (known after apply)
    }

  # aws_route_table.public_route will be created
  + resource "aws_route_table" "public_route" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + core_network_arn           = ""
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = (known after apply)
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = ""
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags             = {
          + "Name" = "rt-t101-study-pub"
        }
      + tags_all         = {
          + "Name" = "rt-t101-study-pub"
        }
      + vpc_id           = (known after apply)
    }

  # aws_route_table_association.public_subnet_association will be created
  + resource "aws_route_table_association" "public_subnet_association" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_security_group.ssh_security will be created
  + resource "aws_security_group" "ssh_security" {
      + arn                    = (known after apply)
      + description            = "Allow 22 inbound"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "221.148.114.22/32",
                ]
              + description      = ""
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
        ]
      + name                   = "ssh-security"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "ssh-security"
        }
      + tags_all               = {
          + "Name" = "ssh-security"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_security_group.web_security will be created
  + resource "aws_security_group" "web_security" {
      + arn                    = (known after apply)
      + description            = "Allow 80 inbound"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 8080
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8080
            },
        ]
      + name                   = "web-security"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "web-security"
        }
      + tags_all               = {
          + "Name" = "web-security"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.public_subnet will be created
  + resource "aws_subnet" "public_subnet" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-northeast-2c"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.10.0.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "sbn-t101-study-pub"
        }
      + tags_all                                       = {
          + "Name" = "sbn-t101-study-pub"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.custom_vpc will be created
  + resource "aws_vpc" "custom_vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.10.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "vpc-t101-study"
        }
      + tags_all                             = {
          + "Name" = "vpc-t101-study"
        }
    }

Plan: 9 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + public_ip = (known after apply)
```

**terraform apply**

```bash
TF_VAR_server_port=8080 TF_VAR_vpc_cidr=10.10.0.0/16 terraform apply
```

