terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    clis = {
      source = "cloud-native-toolkit/clis"
      version = "0.3.0"
    }

  }
}