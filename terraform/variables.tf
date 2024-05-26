
variable "minikube_driver"{
    default = "docker"
}
variable "minikube_cluster_name"{
    default = "terraform-provider-minikube-acc-docker"
}
variable "minikube_addons" {
    type    = list(string)
    default = [
    "default-storageclass",
    "storage-provisioner",
    "metrics-server",
    "ingress"
  ]
}
variable "helm_release_namespace" {
    default = "rustk8s"
}
variable "helm_release_name" {
    default = "rustk8s"
}
variable "helm_chart_path"{
default = "../helm/rustk8s"
}