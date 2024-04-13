resource "kubernetes_service_account" "this" {
  metadata {
    name        = var.service_account_name
    namespace   = var.namespace
    annotations = var.annotations
  }
}

resource "kubernetes_role" "role" {
  count = var.create_role ? 1 : 0

  metadata {
    name = local.role_name
  }

  rule {
    api_groups = var.role_api_groups
    resources  = var.role_resources
    verbs      = var.role_verbs
  }
}

resource "kubernetes_role_binding" "role_binding" {
  count = var.create_role ? 1 : 0

  depends_on = [kubernetes_service_account.this, kubernetes_role.role]

  metadata {
    name      = local.role_binding_name
    namespace = var.namespace
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = local.sa_name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = local.role_name
  }
}

resource "kubernetes_cluster_role" "cluster_role" {
  count = var.create_cluster_role ? 1 : 0

  depends_on = [kubernetes_service_account.this]

  metadata {
    name = local.cluster_role_name
  }

  rule {
    api_groups = var.cluster_role_api_groups
    resources  = var.cluster_role_resources
    verbs      = var.cluster_role_verbs
  }
}

resource "kubernetes_cluster_role_binding" "cluster_binding" {
  count = var.create_cluster_role ? 1 : 0

  depends_on = [kubernetes_service_account.this, kubernetes_cluster_role.cluster_role]

  metadata {
    name = local.cluster_role_binding_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = local.cluster_role_name
  }

  subject {
    kind      = "ServiceAccount"
    name      = local.sa_name
    namespace = var.namespace
  }
}

locals {
  sa_name                   = kubernetes_service_account.this.metadata.0.name
  role_name                 = "${local.sa_name}-role"
  role_binding_name         = "${local.role_name}-binding"
  cluster_role_name         = "${local.sa_name}-cluster-role"
  cluster_role_binding_name = "${local.cluster_role_name}-binding"
}
