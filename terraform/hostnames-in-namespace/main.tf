data "kubernetes_resources" "ingresses_in_namespace" {
  api_version = "networking.k8s.io/v1"
  kind        = "Ingress"
  namespace   = var.namespace
}
