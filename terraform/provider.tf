terraform {
  required_providers {
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.2.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }
  required_version = ">= 1.4.5"
}

provider "hetznerdns" {
  apitoken = var.api_token
}

provider "http" {}

provider "kubernetes" {
  # for local testing uncomment
  #config_path    = "~/.kube/config"
  #config_context = "default"
}