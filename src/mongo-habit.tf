resource "kubernetes_service" "dabit-mongo-habit-service" {
  metadata {
    name = "dabit-mongo-habit-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "dabit"
      service-type = "mongo-habit"
    }

    port {
      port = 27017
      target_port = 27017
    }
  }
}

resource "kubernetes_stateful_set" "dabit-mongo-habit" {
  metadata {
    name = "dabit-mongo-habit-statefulset"
    namespace = var.namespace
    labels = {
      app = "dabit"
      service-type = "mongo-habit"
    }
  }

  spec {
    service_name = "dabit-mongo-habit-service"

    selector {
      match_labels = {
        app = "dabit"
        service-type = "mongo-habit"
      }
    }

    template {
      metadata {
        labels = {
          app = "dabit"
          service-type = "mongo-habit"
        }
      }

      spec {
        container {
          name = "dabit-mongo-habit"
          image = "mongo:latest"
        }
      }
    }
  }
}

