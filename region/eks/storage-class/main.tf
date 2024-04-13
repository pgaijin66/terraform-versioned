variable "name" {
  default = "eks"
}

resource "kubernetes_storage_class" "ssd" {
  metadata {
    name = "${var.name}-ssd"
  }

  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Retain"

  parameters = {
    type = "gp2"
  }
}

