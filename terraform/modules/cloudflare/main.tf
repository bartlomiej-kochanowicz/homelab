# Generate a random secret for the tunnel
resource "random_id" "tunnel_secret" {
  byte_length = 32
}

# Create the Cloudflare Tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "homelab" {
  account_id    = var.cloudflare_account_id
  name          = var.tunnel_name
  tunnel_secret = random_id.tunnel_secret.b64_std
}

# Configure the tunnel with ingress rules
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "homelab" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.homelab.id

  config = {
    ingress = [{
      hostname = "${var.argocd_subdomain}.${var.domain}"
      service  = var.argocd_service_url
      origin_request = {
        no_tls_verify = true
      }
    }]
  }
}

resource "cloudflare_zero_trust_list" "allow_emails_list" {
  account_id = var.cloudflare_account_id
  name       = "Allowed emails list for homelab"
  type       = "EMAIL"
  items      = [for email in var.allowed_emails : { value = email }]
}

# Create Access Policy - Allow specific emails
resource "cloudflare_zero_trust_access_policy" "allow_emails_policy" {
  account_id = var.cloudflare_account_id
  name       = "Allow specific emails to ArgoCD"
  decision   = "allow"

  include = [{
    email_list = {
      id = cloudflare_zero_trust_list.allow_emails_list.id
    }
  }]
}

# Create DNS record pointing to the tunnel
resource "cloudflare_dns_record" "argocd" {
  zone_id = var.cloudflare_zone_id
  name    = var.argocd_subdomain
  content = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "Managed by Terraform - ArgoCD via Cloudflare Tunnel"
  ttl     = 1 # Automatic
}



# Create Cloudflare Access Application for ArgoCD
resource "cloudflare_zero_trust_access_application" "argocd" {
  account_id                = var.cloudflare_account_id
  name                      = "ArgoCD - Homelab"
  domain                    = "${var.argocd_subdomain}.${var.domain}"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = true
  logo_url                  = "https://logo.svgcdn.com/devicon/argocd-original.svg"
  policies = [{
    id = cloudflare_zero_trust_access_policy.allow_emails_policy.id
  }]
}

