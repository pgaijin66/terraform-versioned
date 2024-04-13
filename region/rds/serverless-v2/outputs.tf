output "db_cluster_arn" {
  value = aws_rds_cluster.this.arn
}

output "db_cluster_endpoint" {
  value = aws_rds_cluster.this.endpoint
}

output "db_cluster_reader_endpoint" {
  value = aws_rds_cluster.this.reader_endpoint
}

output "db_cluster_hosted_zone_id" {
  value = aws_rds_cluster.this.hosted_zone_id
}

output "db_cluster_id" {
  value = aws_rds_cluster.this.id
}

output "db_cluster_name" {
  value = aws_rds_cluster.this.database_name
}

output "db_cluster_username" {
  value = aws_rds_cluster.this.master_username
}

output "db_cluster_port" {
  value = aws_rds_cluster.this.port
}

output "db_cluster_members" {
  value = aws_rds_cluster.this.cluster_members
}

output "db_instance_identifier" {
  value = aws_rds_cluster_instance.this.identifier
}

output "db_param_group_name" {
  value = aws_db_parameter_group.this.name
}
