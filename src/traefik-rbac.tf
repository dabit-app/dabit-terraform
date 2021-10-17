resource "kubernetes_cluster_role" "traefik-cluster-role" {
  metadata {
    name = "dabit-traefik-ingress-controller"
  }

  rule {
    api_groups = [""]
    resources = ["services", "endpoints", "secrets"]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"] 
    resources = ["ingresses", "ingressclasses"]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions"]
    resources = ["ingresses/status"]
    verbs = ["update"]
  }
}

resource "kubernetes_cluster_role_binding" "traefik-cluste-role-binding" {
  metadata {
    name = "dabit-traefik-ingress-controller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "dabit-traefik-ingress-controller"
  }

  subject {
    kind = "ServiceAccount"
    name = "dabit-traefik-ingress-controller"
  }
}
