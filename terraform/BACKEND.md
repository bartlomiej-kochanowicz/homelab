# Terraform Backend Configuration

This directory contains backend configuration for Terraform state management.

## 🔒 Security Notice

**`backend.tf` is gitignored** to keep your Terraform Cloud organization and workspace names private.

## 🚀 Setup Options

1. **Create backend.tf from example:**
   ```bash
   cp backend.tf.example backend.tf
   ```

2. **Edit backend.tf with your details:**
   ```hcl
   terraform {
     cloud {
       organization = "your-org-name"
       workspaces {
         name = "homelab-cloudflare"
       }
     }
   }
   ```

3. **Login to Terraform Cloud:**
   ```bash
   terraform login
   ```

4. **Initialize and migrate state:**
   ```bash
   terraform init
   # Answer "yes" to migrate existing state
   ```


