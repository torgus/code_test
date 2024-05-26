resource "minikube_cluster" "docker" {
  driver       = var.minikube_driver
  cluster_name = var.minikube_cluster_name
  addons = var.minikube_addons
}