provider "aws" {
    region = "ap-northeast-2"
}

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "4.10.0" # 2022-04-15
#     }
#   }
#   backend "s3" {
#     bucket = "버킷이름"
#     key    = "terraform-backend/저장될파일명"
#     region = "ap-northeast-2"
#   }
# }