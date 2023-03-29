terraform {
  required_providers {
    azure = {
      source = "hashicorp/azurerm"
    }

    clis = {
      source = "cloud-native-toolkit/clis"
      version = "0.3.0"
    }

  }
}