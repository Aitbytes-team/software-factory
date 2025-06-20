terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.20.0"
    }
  }
}

# Configure the Vault provider
provider "vault" {
  # Token and address should be passed through environment variables
  # VAULT_ADDR and VAULT_TOKEN
}

# Enable GitHub auth method
resource "vault_auth_backend" "github" {
  type = "github"
}

# Configure GitHub auth method
resource "vault_github_auth_backend" "config" {
  organization = var.github_org
  token_type   = "installation"
}

# Create admin policy
resource "vault_policy" "admin" {
  name = "admin"

  policy = <<EOT
# Full access to all paths
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOT
}

# Create developer policy
resource "vault_policy" "developer" {
  name = "developer"

  policy = <<EOT
# Read access to secrets under 'secret/data/terraform/staging'
path "secret/data/terraform/staging/*" {
  capabilities = ["read", "list"]
}

# Read access to secrets under 'secret/data/ansible/staging'
path "secret/data/ansible/staging/*" {
  capabilities = ["read", "list"]
}
EOT
}

# Map GitHub teams to Vault policies
resource "vault_github_team" "admin" {
  backend  = vault_auth_backend.github.path
  team     = var.github_admin_team
  policies = [vault_policy.admin.name]
}

resource "vault_github_team" "developer" {
  backend  = vault_auth_backend.github.path
  team     = var.github_developer_team
  policies = [vault_policy.developer.name]
}

# Enable KV v2 secrets engine
resource "vault_mount" "kv" {
  path        = "secret"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

# ; # Create initial secrets structure
# ; resource "vault_kv_secret_v2" "terraform_staging" {
# ;   mount = vault_mount.kv.path
# ;   name  = "terraform/staging/aws"
# ;   data_json = jsonencode({
# ;     AWS_ACCESS_KEY_ID     = var.aws_access_key
# ;     AWS_SECRET_ACCESS_KEY = var.aws_secret_key
# ;   })
# ; }
# ;
# ; resource "vault_kv_secret_v2" "terraform_production" {
# ;   mount = vault_mount.kv.path
# ;   name  = "terraform/production/aws"
# ;   data_json = jsonencode({
# ;     AWS_ACCESS_KEY_ID     = var.aws_access_key
# ;     AWS_SECRET_ACCESS_KEY = var.aws_secret_key
# ;   })
# ; }

