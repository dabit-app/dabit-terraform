resource "kubernetes_ingress" "traefik-ingress" {
  metadata {
    name = "dabit-traefik-ingress"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class": "traefik"
      "traefik.ingress.kubernetes.io/router.entrypoints": "web,websecure"
      "traefik.ingress.kubernetes.io/router.tls": "true"
    }
    labels = {
      app = "dabit"
    }
  }
  
  spec {
    rule {
      host = var.host
      http {
        path {
          path = "/api/habit/"
          backend {
            service_name = "dabit-habit-api-service"
            service_port = 80
          }
        }

        path {
          path = "/api/auth/"
          backend {
            service_name = "dabit-identity-api-service"
            service_port = 80
          }
        }
      }
    }
  }
}
