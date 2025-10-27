output "tunnel_id" {
  description = "The ID of the Cloudflare Tunnel"
  value       = cloudflare_tunnel.homelab.id
}

output "tunnel_token" {
  description = "The tunnel token for cloudflared (sensitive)"
  value       = cloudflare_tunnel.homelab.tunnel_token
  sensitive   = true
}

output "argocd_url" {
  description = "Public URL for ArgoCD"
  value       = "https://${var.argocd_subdomain}.${var.domain}"
}

output "tunnel_cname" {
  description = "CNAME record for the tunnel"
  value       = "${cloudflare_tunnel.homelab.id}.cfargotunnel.com"
}

output "access_application_id" {
  description = "Cloudflare Access Application ID"
  value       = cloudflare_access_application.argocd.id
}
