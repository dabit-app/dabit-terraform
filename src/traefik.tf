resource "kubernetes_service_account" "traefik-service-account" {
  metadata {
    name = "dabit-traefik-ingress-controller"
    namespace = var.namespace
  }
}

resource "kubernetes_deployment" "traefik" {
  metadata {
    name = "dabit-traefik-deployment"
    namespace = var.namespace
    labels = {
      app = "dabit"
      service-type = "traefik"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "dabit"
        service-type = "traefik"
      }
    }

    template {
      metadata {
        namespace = var.namespace
        labels = {
          app = "dabit"
          service-type = "traefik"
        }
      }

      spec {
        service_account_name = "dabit-traefik-ingress-controller"

        container {
          image = "traefik:v2.5"
          name = "traefik"

          args = [
            "--providers.kubernetesingress=true",
            "--entrypoints.web.address=:80",
            "--entrypoints.websecure.address=:443",
            "--api.dashboard=true",
            "--api.insecure=true"
          ]

          port {
            name = "web"
            container_port = 80
          }

          port {
            name = "websecure"
            container_port = 443
          }

          port {
            name = "dashboard"
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "traefik-service" {
  metadata {
    name = "dabit-traefik-service"
    namespace = var.namespace
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "dabit"
      service-type = "traefik"
    }

    port {
      name = "web"
      port = 80
      target_port = 80
    }

    port {
      name = "websecure"
      port = 443
      target_port = 443
    }
  }
}

