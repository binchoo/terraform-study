terraform {
  required_providers {
    jq = {
      source  = "massdriver-cloud/jq"
      version = "0.2.0"
    }
  }
}

provider "jq" {}

provider "aws" {
  region = "ap-northeast-2"
}
