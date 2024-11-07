terraform {
  required_version = ">= 1.9.8"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.8.1"
    }

    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}
