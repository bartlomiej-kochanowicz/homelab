variable "cloudflare_api_token" {
  description = "Cloudflare API token with permissions for Tunnel, Access, and DNS"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for your domain"
  type        = string
}

variable "domain" {
  description = "Base domain name (e.g., example.com)"
  type        = string
}

variable "argocd_subdomain" {
  description = "Subdomain for ArgoCD (e.g., argocd)"
  type        = string
  default     = "argocd"
}

variable "tunnel_name" {
  description = "Name for the Cloudflare Tunnel"
  type        = string
  default     = "homelab-tunnel"
}

variable "argocd_service_url" {
  description = "Internal Kubernetes service URL for ArgoCD"
  type        = string
  default     = "https://argocd-server.argocd.svc.cluster.local"
}

variable "allowed_emails" {
  description = "List of email addresses allowed to access ArgoCD via Cloudflare Access"
  type        = list(string)
  default     = []
}
