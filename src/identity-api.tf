resource "kubernetes_deployment" "dabit-identity-api" {
  metadata {
    name = "dabit-identity-api-deployment"
    namespace = var.namespace
    labels = {
      app = "dabit"
      service-type = "identity-api"
    }
  }

  spec {
    replicas = var.identity_api_replicas

    selector {
      match_labels = {
        app = "dabit"
        service-type = "identity-api"
      }
    }

    template {
      metadata {
        namespace = var.namespace
        labels = {
          app = "dabit"
          service-type = "identity-api"
        }
      }

      spec {
        container {
          image = "ghcr.io/dabit-app/dabit-server-identity-api:main"
          name = "dabit-identity-api"

          port {
            container_port = 80
          }

          env {
            name = "ConnectionStrings__dabit-user-mongo-db"
            value_from {
              config_map_key_ref {
                name = "dabit-configmap"
                key = "mongo-user-url"
              }
            }
          }

          env {
            name = "Provider__Google__Audience"
            value_from {
              config_map_key_ref {
                name = "dabit-configmap"
                key = "google-audience"
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

resource "kubernetes_service" "dabit-identity-api-service" {
  metadata {
    name = "dabit-identity-api-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "dabit"
      service-type = "identity-api"
    }

    port {
      port = 80
      target_port = 80
    }
  }
}
