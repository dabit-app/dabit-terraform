resource "kubernetes_config_map" "dabit-configmap" {
  metadata {
    name = "dabit-configmap"
    namespace = var.namespace
  }

  data = {
    event-store-url = "esdb://dabit-event-store-service:2113?tls=false"
    mongo-habit-url = "mongodb://dabit-mongo-habit-service:27017"
    mongo-user-url = "mongodb://dabit-mongo-user-service:27018"
    google-audience = "668126892844-9qe8e5u4mdg0o1epcl0j8lnbe5hdodfj.apps.googleusercontent.com"
  }
}


