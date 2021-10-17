resource "kubernetes_deployment" "dabit-habit-api" {
  metadata {
    name = "dabit-habit-api-deployment"
    namespace = var.namespace
    labels = {
      app = "dabit"
      service-type = "habit-api"
    }
  }

  spec {
    replicas = var.habit_api_replicas

    selector {
      match_labels = {
        app = "dabit"
        service-type = "habit-api"
      }
    }

    template {
      metadata {
        namespace = var.namespace
        labels = {
          app = "dabit"
          service-type = "habit-api"
        }
      }

      spec {
        container {
          image = "ghcr.io/dabit-app/dabit-server-habit-api:main"
          name = "dabit-habit-api"

          port {
            container_port = 80
          }

          env {
            name = "ConnectionStrings__dabit-event-store-db"
            value_from {
              config_map_key_ref {
                name = "dabit-configmap"
                key = "event-store-url"
              }
            }
          }

          env {
            name = "ConnectionStrings__dabit-mongo-db"
            value_from {
              config_map_key_ref {
                name = "dabit-configmap"
                key = "mongo-habit-url"
              }
            }
          }

          env {
            name = "JWT__Secret"
            value_from {
              secret_key_ref {
                name = "dabit-secret"
                key = "jwt-secret"
              }
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 80
            }

            initial_delay_seconds = 5
          }

        }
      }
    }
  }
}

resource "kubernetes_service" "dabit-habit-api-service" {
  metadata {
    name = "dabit-habit-api-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "dabit"
      service-type = "habit-api"
    }

    port {
      port = 80
      target_port = 80
    }
  }
}
