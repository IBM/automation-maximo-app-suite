terraform {
  required_providers {
    gitops = {
      source = "cloud-native-toolkit/gitops"
    }

    clis = {
      source = "cloud-native-toolkit/clis"
      version = "0.3.0"
    }

    ibm = {
      source = "ibm-cloud/ibm"
    }

  }
}