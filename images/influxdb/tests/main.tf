terraform {
  required_providers {
    oci  = { source = "chainguard-dev/oci" }
    helm = { source = "hashicorp/helm" }
  }
}

variable "digest" {
  description = "The image digest to run tests over."
}

data "oci_string" "ref" { input = var.digest }

resource "helm_release" "influxdb" {
  name = "influxdb"

  repository = "https://helm.influxdata.com"
  chart      = "influxdb2"

  namespace        = "influxdb"
  create_namespace = true


  values = [jsonencode({
    image = {
      tag        = data.oci_string.ref.pseudo_tag
      repository = data.oci_string.ref.registry_repo
    }
  })]
}

module "helm_cleanup" {
  source    = "../../../tflib/helm-cleanup"
  name      = helm_release.influxdb.id
  namespace = helm_release.influxdb.namespace
}
