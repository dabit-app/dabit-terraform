resource "kubernetes_namespace" "dabit-namespace" {
  metadata {
    labels = {
      app = "dabit"
    }

    name = var.namespace
  }
  count = var.namespace != "default" ? 1 : 0
}
