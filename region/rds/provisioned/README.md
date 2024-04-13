# RDS Provisioned Instance

Pleae pre-read this [FAQ](../README.md) for how to set up your Database password and other common RDS features

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_kms_key.aws_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | Amount of allocated storage to provision for the RDS instance | `string` | n/a | yes |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Whether to allow major version upgrades for the RDS instance. If not specified, value is `true` if `capsule_env != production` else `false`. | `bool` | `null` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Whether to apply the changes to the instance configuration and parameter group immediately | `bool` | `true` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Whether to apply minor version upgrades automatically for the RDS instance | `bool` | `true` | no |
| <a name="input_auto_shutdown"></a> [auto\_shutdown](#input\_auto\_shutdown) | Enables auto shutdown for the instance during off-hours, performed by the startRDS/stopRDS Lambdas. If not specified, value is `true` if `capsule_env == dev` else `false`. | `bool` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability zone to use for the RDS instance | `string` | `""` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Number of days to retain automated backups. Default: 30 for production (can be overriden), 5 for non-production (fixed) | `number` | `30` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Time window to use for automated backups | `string` | `"04:00-04:30"` | no |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | Environment that the RDS instance is in | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | Service that uses the RDS instance | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | Team that maintains the RDS instance | `string` | n/a | yes |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name of the DB subnet group to use for the RDS instance | `string` | `""` | no |
| <a name="input_delete_automated_backups"></a> [delete\_automated\_backups](#input\_delete\_automated\_backups) | Whether to delete automated backups after the RDS instance is deleted | `bool` | `false` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether to enable deletion protection for the RDS instance. Value is `true` when `capsule_env == production` else `false` (can be overriden). | `bool` | `false` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of enabled cloudwatch logs exports | `list(string)` | `[]` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Database engine to use | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Database engine version to use | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | RDS instance class to use | `string` | n/a | yes |
| <a name="input_iops"></a> [iops](#input\_iops) | Amount of IOPS to provision for the RDS instance, used only when `storage_type == io1` | `number` | `0` | no |
| <a name="input_legacy_identifier"></a> [legacy\_identifier](#input\_legacy\_identifier) | Legacy identifier for the RDS instance, can be used when db name does not conform to `servicename-environment` format | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window to use for the RDS instance | `string` | `"sun:06:00-sun:06:30"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | Maximum amount of allocated storage to provision for the RDS instance | `number` | `0` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Whether to use a multi-AZ deployment for the RDS instance. Value is `true` if `capsule_env == production` else `false` (can be overriden). | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the RDS instance | `string` | `""` | no |
| <a name="input_option_group_name"></a> [option\_group\_name](#input\_option\_group\_name) | Name of the option group to use for the RDS instance | `string` | `""` | no |
| <a name="input_param_group_family"></a> [param\_group\_family](#input\_param\_group\_family) | Database parameter group family to use | `string` | n/a | yes |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | List of database parameter group parameters to use | `list(map(string))` | `[]` | no |
| <a name="input_password"></a> [password](#input\_password) | At least 8 printable ASCII characters. Can't contain any of the following: / (slash), '(single quote), "(double quote) and @ (at sign). | `string` | n/a | yes |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Whether to enable Performance Insights. Value is `true` when `capsule_env == production` else `false` (can be overriden). | `bool` | `false` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | Amount of time in days to retain Performance Insights data (if enabled) | `number` | `7` | no |
| <a name="input_port"></a> [port](#input\_port) | Port to use for the RDS instance | `string` | `"5432"` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Whether to skip the final snapshot after the RDS instance is deleted | `bool` | `false` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Snapshot identifier to use for the RDS instance | `string` | `""` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Storage type to use for the RDS instance | `string` | `"gp2"` | no |
| <a name="input_username"></a> [username](#input\_username) | Master username for the RDS instance | `string` | n/a | yes |
| <a name="input_vanta_contains_ephi"></a> [vanta\_contains\_ephi](#input\_vanta\_contains\_ephi) | Vanta specific tag to specify if the resource contains electronic protected health information (ePHI) | `bool` | `false` | no |
| <a name="input_vanta_description"></a> [vanta\_description](#input\_vanta\_description) | Vanta specific tag to specify the purpose of resource | `string` | `"RDS Service"` | no |
| <a name="input_vanta_nonprod"></a> [vanta\_nonprod](#input\_vanta\_nonprod) | Vanta specific tag to indicate if the resource is non-prod | `bool` | `true` | no |
| <a name="input_vanta_owner"></a> [vanta\_owner](#input\_vanta\_owner) | Vanta specific tag to identify resource owner | `string` | `"Global"` | no |
| <a name="input_vanta_user_data"></a> [vanta\_user\_data](#input\_vanta\_user\_data) | Vanta specific tag to specify if the resource will contain user data | `bool` | `false` | no |
| <a name="input_vanta_user_data_stored"></a> [vanta\_user\_data\_stored](#input\_vanta\_user\_data\_stored) | Vanta specific tag to specify the type of data the resource transacts/stores | `string` | `"None"` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | IDs of the VPC security groups to apply to the RDS instance | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_backup_retention_period"></a> [db\_backup\_retention\_period](#output\_db\_backup\_retention\_period) | n/a |
| <a name="output_db_instance_address"></a> [db\_instance\_address](#output\_db\_instance\_address) | n/a |
| <a name="output_db_instance_arn"></a> [db\_instance\_arn](#output\_db\_instance\_arn) | n/a |
| <a name="output_db_instance_availability_zone"></a> [db\_instance\_availability\_zone](#output\_db\_instance\_availability\_zone) | n/a |
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | n/a |
| <a name="output_db_instance_hosted_zone_id"></a> [db\_instance\_hosted\_zone\_id](#output\_db\_instance\_hosted\_zone\_id) | n/a |
| <a name="output_db_instance_id"></a> [db\_instance\_id](#output\_db\_instance\_id) | n/a |
| <a name="output_db_instance_identifier"></a> [db\_instance\_identifier](#output\_db\_instance\_identifier) | n/a |
| <a name="output_db_instance_name"></a> [db\_instance\_name](#output\_db\_instance\_name) | n/a |
| <a name="output_db_instance_port"></a> [db\_instance\_port](#output\_db\_instance\_port) | n/a |
| <a name="output_db_instance_username"></a> [db\_instance\_username](#output\_db\_instance\_username) | n/a |
| <a name="output_db_param_group_name"></a> [db\_param\_group\_name](#output\_db\_param\_group\_name) | n/a |
<!-- END_TF_DOCS -->
