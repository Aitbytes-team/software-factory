variable "github_org" {
  description = "GitHub organization name"
  type        = string
}

variable "github_admin_team" {
  description = "GitHub team name for admin access"
  type        = string
}

variable "github_developer_team" {
  description = "GitHub team name for developer access"
  type        = string
}

# variable "aws_access_key" {
#   description = "AWS access key"
#   type        = string
#   sensitive   = true
# }
#
# variable "aws_secret_key" {
#   description = "AWS secret key"
#   type        = string
#   sensitive   = true
# }

