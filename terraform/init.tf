terraform {
  required_providers {
    minikube = {
      source = "scott-the-programmer/minikube"
    }
  }
}

provider "minikube" {
}

provider "helm" {
  kubernetes{
    host = minikube_cluster.docker.host
    client_certificate     = minikube_cluster.docker.client_certificate
    client_key             = minikube_cluster.docker.client_key
    cluster_ca_certificate = minikube_cluster.docker.cluster_ca_certificate
  }
}
