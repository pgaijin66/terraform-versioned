resource "aws_iam_openid_connect_provider" "provider" {
  url             = var.url
  client_id_list  = var.audiences
  thumbprint_list = var.thumbprints
}
