data "http" "ifconfig_ip" {
  url = "https://ifconfig.me/ip"
}

data "kubernetes_resources" "namespaces" {
  api_version = "v1"
  kind        = "Namespace"
}

locals {
  domain_with_dot_postfix = join("", [var.domain, "."])
  domain_with_dot_prefix  = join("", [".", var.domain, "."])

  hostnames = distinct(flatten([for hostnames_in_namespace in module.hostnames_in_namespaces : hostnames_in_namespace.hostnames]))

  # convert entries for hetznerdns_record
  # if the hostname is exact the zone domain return an @ for the A record
  # if the hostname is a subdomain of the zone domain extract the subdomain part
  hetzner_subdomains = [
    for hostname in local.hostnames : hostname == local.domain_with_dot_postfix ? "@" : (endswith(hostname, local.domain_with_dot_prefix) ? trimsuffix(hostname, local.domain_with_dot_prefix) : "")
  ]
}

module "hostnames_in_namespaces" {
  for_each  = toset([for namespace_object in data.kubernetes_resources.namespaces.objects : namespace_object.metadata.name])
  source    = "./hostnames-in-namespace/"
  namespace = each.key
}

data "hetznerdns_zone" "zone" {
  name = var.domain
}

resource "hetznerdns_record" "records" {
  for_each = toset(local.hetzner_subdomains)
  zone_id  = data.hetznerdns_zone.zone.id
  name     = each.key
  value    = data.http.ifconfig_ip.response_body
  type     = "A"
  ttl      = var.ttl
}