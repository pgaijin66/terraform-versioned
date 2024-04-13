data "aws_kms_key" "rds" {
  key_id = "alias/aws/rds"
}

resource "aws_db_instance_automated_backups_replication" "this" {
  source_db_instance_arn = var.source_db_arn
  kms_key_id             = data.aws_kms_key.rds.arn
  retention_period       = var.retention_period
}
