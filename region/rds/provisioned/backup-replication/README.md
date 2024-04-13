<!-- BEGIN_TF_DOCS -->
## Requirements

This module can only be used for AWS RDS Instances, not Aurora clusters.
This module **must** be used in the destination region. Do this by setting the `providers` block:
```
module "db_backup_replication" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/rds/provisioned/backup-replication"

  providers = {
    aws = aws.uswest2
  }

  source_db_arn = module.my_db.db_instance_arn
}
```
Please take a look at the [test example](./tests/rds/example.tf) for usage.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance_automated_backups_replication.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance_automated_backups_replication) | resource |
| [aws_kms_key.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_retention_period"></a> [retention\_period](#input\_retention\_period) | Retention period for backups | `number` | `14` | no |
| <a name="input_source_db_arn"></a> [source\_db\_arn](#input\_source\_db\_arn) | The ARN of the source database instance. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
