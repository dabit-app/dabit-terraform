resource "kubernetes_service" "dabit-event-store-service" {
  metadata {
    name = "dabit-event-store-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "dabit"
      service-type = "event-store"
    }

    port {
      port = 2113
      target_port = 2113
    }
  }
}

resource "kubernetes_stateful_set" "dabit-event-store" {
  metadata {
    name = "dabit-event-store-statefulset"
    namespace = var.namespace
    labels = {
      app = "dabit"
      service-type = "event-store"
    }
  }

  spec {
    service_name = "dabit-event-store-service"

    selector {
      match_labels = {
        app = "dabit"
        service-type = "event-store"
      }
    }

    template {
      metadata {
        labels = {
          app = "dabit"
          service-type = "event-store"
        }
      }

      spec {
        container {
          name = "dabit-event-store"
          image = "eventstore/eventstore:21.6.0-buster-slim"

          env {
            name = "EVENTSTORE_CLUSTER_SIZE"
            value = "1"
          }

          env {
            name = "EVENTSTORE_INSECURE"
            value = "true"
          }

          env {
            name = "EVENTSTORE_HTTP_PORT"
            value = "2113"
          }

          port {
            container_port = "2113"
          }
        }
      }
    }
  }
}

