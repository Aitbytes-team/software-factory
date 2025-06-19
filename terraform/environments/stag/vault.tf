module "vault_config" {
  source = "../../modules/vault_config"

  github_org           = "aitbytes-team"  # or organization name
  github_admin_team    = "admins"
  github_developer_team = "developers"
  
}

