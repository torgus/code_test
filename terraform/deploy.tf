resource "helm_release" "rustk8s" {
  name             = var.helm_release_name
  chart            = var.helm_chart_path
  namespace        = var.helm_release_namespace
  create_namespace = true
  values = [
    "${file("../helm_values/${terraform.workspace}/values.yaml")}"
  ]
}