#############
# NAMESPACE #
#############
resource "kubernetes_namespace" "namespace" {
  metadata {
    labels = {
      name = var.namespace_name
    }

    name = var.namespace_name
  }
}

#########
# Roles #
#########
resource "kubernetes_role" "read_role" {
  depends_on = [kubernetes_namespace.namespace]

  metadata {
    name      = local.read_role_name
    namespace = local.namespace_name
  }

  rule {
    api_groups = ["", "extensions", "apps"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role" "admin_role" {
  depends_on = [kubernetes_namespace.namespace]

  metadata {
    name      = local.admin_role_name
    namespace = local.namespace_name
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

################
# Role Binding #
################
resource "kubernetes_role_binding" "read_role_binding" {
  depends_on = [
    kubernetes_namespace.namespace,
    kubernetes_role.read_role,
  ]

  metadata {
    name      = local.read_role_binding_name
    namespace = local.namespace_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = local.read_role_name
  }

  subject {
    kind = "Group"
    name = "capsule:${local.read_role_name}"
  }
}

resource "kubernetes_role_binding" "admin_role_binding" {
  depends_on = [
    kubernetes_namespace.namespace,
    kubernetes_role.admin_role,
  ]

  metadata {
    name      = local.admin_role_binding_name
    namespace = local.namespace_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = local.admin_role_name
  }

  subject {
    kind = "Group"
    name = "capsule:${local.admin_role_name}"
  }
}

locals {
  namespace_name          = kubernetes_namespace.namespace.metadata.0.name
  admin_role_name         = "${local.namespace_name}-admin"
  read_role_name          = "${local.namespace_name}-read"
  admin_role_binding_name = "${local.admin_role_name}-role-binding"
  read_role_binding_name  = "${local.read_role_name}-role-binding"
}
