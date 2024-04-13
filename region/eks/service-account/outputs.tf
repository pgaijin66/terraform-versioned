output "sa_secret_name" {
  value = kubernetes_service_account.this.default_secret_name
}

output "sa_name" {
  value = kubernetes_service_account.this.metadata.0.name
}
