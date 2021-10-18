provider "kubernetes" {
  config_path = var.k8s_config_context != null ? var.k8s_config_path : null
  config_context = var.k8s_config_context != null ? var.k8s_config_context : null

  host = var.k8s_host != null ? var.k8s_host : null
  client_certificate = var.k8s_host != null ? base64decode(var.k8s_client_certificate) : null
  client_key = var.k8s_host != null ? base64decode(var.k8s_client_key) : null
  cluster_ca_certificate = var.k8s_host != null ? base64decode(var.k8s_cluster_ca_certificate) : null
}

provider "helm" {
  kubernetes {
    config_path = var.k8s_config_context != null ? var.k8s_config_path : null
    config_context = var.k8s_config_context != null ? var.k8s_config_context : null

    host = var.k8s_host != null ? var.k8s_host : null
    client_certificate = var.k8s_host != null ? base64decode(var.k8s_client_certificate) : null
    client_key = var.k8s_host != null ? base64decode(var.k8s_client_key) : null
    cluster_ca_certificate = var.k8s_host != null ? base64decode(var.k8s_cluster_ca_certificate) : null
  }
}

