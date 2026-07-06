terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

resource "helm_release" "podinfo" {
  name             = "podinfo"
  namespace        = "podinfo"
  create_namespace = true
  repository       = "https://stefanprodan.github.io/podinfo"
  chart            = "podinfo"
  version          = var.chart_version
}