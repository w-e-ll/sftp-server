terraform {
  required_version = "~> 0.12.24"
}

provider "alks" {
  url              = "https://alks.coxautoinc.com/rest"
  version          = "~> 1.3.0"
}

provider "aws" {
  version          = ">= 2.27.0"
  region           = "us-east-1"
}
