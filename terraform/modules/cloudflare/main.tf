# Generate a random secret for the tunnel
resource "random_id" "tunnel_secret" {
  byte_length = 32
}

# Create the Cloudflare Tunnel
resource "cloudflare_tunnel" "homelab" {
  account_id = var.cloudflare_account_id
  name       = var.tunnel_name
  secret     = random_id.tunnel_secret.b64_std
}

# Configure the tunnel with ingress rules
resource "cloudflare_tunnel_config" "homelab" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_tunnel.homelab.id

  config {
    # Route traffic for argocd subdomain to the ArgoCD service
    ingress_rule {
      hostname = "${var.argocd_subdomain}.${var.domain}"
      service  = var.argocd_service_url
      origin_request {
        # Disable TLS verification for internal service
        no_tls_verify = true
      }
    }

    # Catch-all rule (required by Cloudflare)
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# Create DNS record pointing to the tunnel
resource "cloudflare_record" "argocd" {
  zone_id = var.cloudflare_zone_id
  name    = var.argocd_subdomain
  value   = "${cloudflare_tunnel.homelab.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  comment = "Managed by Terraform - ArgoCD via Cloudflare Tunnel"
}

# Create Cloudflare Access Application for ArgoCD
resource "cloudflare_access_application" "argocd" {
  account_id                = var.cloudflare_account_id
  name                      = "ArgoCD - Homelab"
  domain                    = "${var.argocd_subdomain}.${var.domain}"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = true
  app_launcher_logo_url     = "https://logo.svgcdn.com/devicon/argocd-original.svg"
}

# Create Access Policy - Allow specific emails
resource "cloudflare_access_policy" "argocd_allow_emails" {
  count = length(var.allowed_emails) > 0 ? 1 : 0

  application_id = cloudflare_access_application.argocd.id
  account_id     = var.cloudflare_account_id
  name           = "Allow specific users"
  precedence     = 1
  decision       = "allow"

  include {
    email = var.allowed_emails
  }
}
