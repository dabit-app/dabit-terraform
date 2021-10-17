resource "kubernetes_service" "dabit-mongo-user-service" {
  metadata {
    name = "dabit-mongo-user-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "dabit"
      service-type = "mongo-user"
    }

    port {
      port = 27018
      target_port = 27017
    }
  }
}

resource "kubernetes_stateful_set" "dabit-mongo-user" {
  metadata {
    name = "dabit-mongo-user-statefulset"
    namespace = var.namespace
    labels = {
      app = "dabit"
      service-type = "mongo-user"
    }
  }

  spec {
    service_name = "dabit-mongo-user-service"

    selector {
      match_labels = {
        app = "dabit"
        service-type = "mongo-user"
      }
    }

    template {
      metadata {
        labels = {
          app = "dabit"
          service-type = "mongo-user"
        }
      }

      spec {
        container {
          name = "dabit-mongo-user"
          image = "mongo:latest"
        }
      }
    }
  }
}

