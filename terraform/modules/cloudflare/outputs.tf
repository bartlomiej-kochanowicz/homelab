output "tunnel_id" {
  description = "The ID of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.homelab.id
}

output "argocd_url" {
  description = "Public URL for ArgoCD"
  value       = "https://${var.argocd_subdomain}.${var.domain}"
}

output "tunnel_cname" {
  description = "CNAME record for the tunnel"
  value       = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"
}

output "access_application_id" {
  description = "Cloudflare Access Application ID"
  value       = cloudflare_zero_trust_access_application.argocd.id
}
