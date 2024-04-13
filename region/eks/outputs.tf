output "cluster_arn" {
  description = "The ARN for your EKS Cluster"
  value       = module.eks.cluster_arn
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API"
  value       = module.eks.cluster_endpoint
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = module.eks.cluster_iam_role_arn
}

output "cluster_id" {
  description = "The ID for your EKS Cluster"
  value       = module.eks.cluster_id
}

output "cluster_oidc_issuer_url" {
  description = "The OIDC Issuer URL for your EKS Cluster"
  value       = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  description = " The ARN of the OIDC Provider"
  value       = module.eks.oidc_provider_arn
}
