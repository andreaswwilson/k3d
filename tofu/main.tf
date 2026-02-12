resource "kubernetes_namespace" "andreas" {
  metadata {
    name = "andreas"
  }
}

resource "kubernetes_secret" "tls" {
  metadata {
    name      = "andreas-local-tls"
    namespace = kubernetes_namespace.andreas.metadata[0].name
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = file(var.tls_cert_path)
    "tls.key" = file(var.tls_key_path)
  }
}

resource "kubernetes_secret" "postgres_credentials" {
  metadata {
    name      = "postgres-credentials"
    namespace = kubernetes_namespace.andreas.metadata[0].name
  }

  data = {
    password = var.postgres_password
  }
}

resource "kubernetes_manifest" "frontend" {
  for_each = {
    for idx, doc in [
      for doc in split("---", file("${path.module}/../manifests/frontend.yml")) : doc if trimspace(doc) != ""
    ] : idx => yamldecode(doc)
  }

  manifest = each.value

  depends_on = [kubernetes_namespace.andreas]
}

resource "kubernetes_manifest" "backend" {
  for_each = {
    for idx, doc in [
      for doc in split("---", file("${path.module}/../manifests/backend.yml")) : doc if trimspace(doc) != ""
    ] : idx => yamldecode(doc)
  }

  manifest = each.value

  depends_on = [kubernetes_namespace.andreas]
}

resource "kubernetes_manifest" "postgres" {
  for_each = {
    for idx, doc in [
      for doc in split("---", file("${path.module}/../manifests/postgres.yml")) : doc if trimspace(doc) != ""
    ] : idx => yamldecode(doc)
  }

  manifest = each.value

  depends_on = [kubernetes_namespace.andreas, kubernetes_secret.postgres_credentials]
}

resource "kubernetes_manifest" "ingress" {
  for_each = {
    for idx, doc in [
      for doc in split("---", file("${path.module}/../manifests/ingress.yml")) : doc if trimspace(doc) != ""
    ] : idx => yamldecode(doc)
  }

  manifest = each.value

  depends_on = [kubernetes_namespace.andreas, kubernetes_secret.tls]
}
