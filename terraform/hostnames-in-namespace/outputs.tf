output "hostnames" {
  value = distinct(compact([for ingress_object in data.kubernetes_resources.ingresses_in_namespace.objects : lookup(ingress_object.metadata.annotations, "external-dns.alpha.kubernetes.io/hostname", "")]))
}