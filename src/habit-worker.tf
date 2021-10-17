resource "kubernetes_deployment" "dabit-habit-worker" {
  metadata {
    name = "dabit-habit-worker-deployment"
    namespace = var.namespace
    labels = {
      app = "dabit"
      service-type = "habit-worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "dabit"
        service-type = "habit-worker"
      }
    }

    template {
      metadata {
        namespace = var.namespace
        labels = {
          app = "dabit"
          service-type = "habit-worker"
        }
      }

      spec {
        container {
          image = "ghcr.io/dabit-app/dabit-server-habit-worker:main"
          name = "dabit-habit-worker"

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

          liveness_probe {
            exec {
              command = ["cat", "/tmp/healthy"]
            }

            initial_delay_seconds = 5
          }
        }

      }
    }
  }
}
