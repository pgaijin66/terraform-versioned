locals {
  tags = {
    terraform         = "true"
    "capsule:env"     = var.capsule_env
    "capsule:team"    = var.capsule_team
    "capsule:service" = "grafana"
  }

  name = var.name != null ? "${var.capsule_service}-cloudwatch-read-${var.name}-${var.capsule_env}" : "${var.capsule_service}-cloudwatch-read-${var.capsule_env}"
}
