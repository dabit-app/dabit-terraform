resource "kubernetes_secret" "dabit-secret" {
  metadata {
    name = "dabit-secret"
    namespace = var.namespace
  }

  type = "Opaque"

  data = {
    jwt-secret = random_password.dabit-jwt-secret.result
  }
}

resource "random_password" "dabit-jwt-secret" {
  length = 64
}
