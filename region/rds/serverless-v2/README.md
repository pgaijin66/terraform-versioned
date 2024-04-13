# RDS Serverless V2

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
| [aws_db_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_rds_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_kms_key.aws_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Whether to allow automatic major version upgrades | `bool` | `false` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Whether to apply Database modifications immediately | `bool` | `true` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Whether to apply minor version upgrades automatically | `bool` | `true` | no |
| <a name="input_auto_shutdown"></a> [auto\_shutdown](#input\_auto\_shutdown) | Optional tag that enables auto shutdown for the instance/cluster during off-hours, performed by the startRDS/stopRDS Lambdas | `bool` | `false` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Number of days to retain automated backups. Default: 30 for production (can be overriden), 5 for non-production (fixed) | `number` | `30` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Time window to use for automated backups | `string` | `"04:00-04:30"` | no |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | Environment that the infra is in | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | Service that uses the infra | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | Team that maintains the infra | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name for an automatically created database on creation. If not specified, `service_name` is used by default | `string` | `null` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name of the DB subnet group to use | `string` | `""` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether to enable deletion protection. Defaults to `true` when `capsule_env == production` `false` otherwise | `bool` | `false` | no |
| <a name="input_engine_major_version"></a> [engine\_major\_version](#input\_engine\_major\_version) | Aurora Postgres major version - used only for the Parameter Group family | `string` | `"14"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Aurora Postgres engine version. Must be in the format of `<major>.<minor>` | `string` | `"14.5"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Instance class to use for the provisioned instances | `string` | `"db.serverless"` | no |
| <a name="input_legacy_identifier"></a> [legacy\_identifier](#input\_legacy\_identifier) | Legacy identifier for the Serverless instance, can be used when name does not conform to `service-environment-provisioned-1` format | `string` | `null` | no |
| <a name="input_legacy_name"></a> [legacy\_name](#input\_legacy\_name) | Legacy name for the Serverless cluster, can be used when name does not conform to `service-environment-provisioned` format | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window to apply updates | `string` | `"sun:06:00-sun:06:30"` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | The max capacity of the server. Valid capacity values are between `0.5` and `128` in increments of `0.5` | `number` | n/a | yes |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Starting capacity of the server. Valid capacity values are between `0.5` and `128` in increments of `0.5` | `number` | `0.5` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | List of database parameter group parameters to use | `list(map(string))` | `[]` | no |
| <a name="input_password"></a> [password](#input\_password) | Master DB password. At least 8 printable ASCII characters. Can't contain any of the following: / (slash), '(single quote), "(double quote) and @ (at sign). | `string` | n/a | yes |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Whether to enable Performance Insights. Defaults to `true` when `capsule_env == production` `false` otherwise | `bool` | `false` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | Amount of time in days to retain Performance Insights data (if enabled) | `number` | `7` | no |
| <a name="input_username"></a> [username](#input\_username) | Master DB username | `string` | `null` | no |
| <a name="input_vanta_contains_ephi"></a> [vanta\_contains\_ephi](#input\_vanta\_contains\_ephi) | Vanta specific tag to specify if the resource contains electronic protected health information (ePHI) | `bool` | `false` | no |
| <a name="input_vanta_description"></a> [vanta\_description](#input\_vanta\_description) | Vanta specific tag to specify the purpose of resource | `string` | `"RDS ServerlessV2 Service"` | no |
| <a name="input_vanta_nonprod"></a> [vanta\_nonprod](#input\_vanta\_nonprod) | Vanta specific tag to indicate if the resource is non-prod | `bool` | `true` | no |
| <a name="input_vanta_owner"></a> [vanta\_owner](#input\_vanta\_owner) | Vanta specific tag to identify resource owner | `string` | `"Global"` | no |
| <a name="input_vanta_user_data"></a> [vanta\_user\_data](#input\_vanta\_user\_data) | Vanta specific tag to specify if the resource will contain user data | `bool` | `false` | no |
| <a name="input_vanta_user_data_stored"></a> [vanta\_user\_data\_stored](#input\_vanta\_user\_data\_stored) | Vanta specific tag to specify the type of data the resource transacts/stores | `string` | `"None"` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | IDs of the VPC security groups | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_cluster_arn"></a> [db\_cluster\_arn](#output\_db\_cluster\_arn) | n/a |
| <a name="output_db_cluster_endpoint"></a> [db\_cluster\_endpoint](#output\_db\_cluster\_endpoint) | n/a |
| <a name="output_db_cluster_hosted_zone_id"></a> [db\_cluster\_hosted\_zone\_id](#output\_db\_cluster\_hosted\_zone\_id) | n/a |
| <a name="output_db_cluster_id"></a> [db\_cluster\_id](#output\_db\_cluster\_id) | n/a |
| <a name="output_db_cluster_members"></a> [db\_cluster\_members](#output\_db\_cluster\_members) | n/a |
| <a name="output_db_cluster_name"></a> [db\_cluster\_name](#output\_db\_cluster\_name) | n/a |
| <a name="output_db_cluster_port"></a> [db\_cluster\_port](#output\_db\_cluster\_port) | n/a |
| <a name="output_db_cluster_reader_endpoint"></a> [db\_cluster\_reader\_endpoint](#output\_db\_cluster\_reader\_endpoint) | n/a |
| <a name="output_db_cluster_username"></a> [db\_cluster\_username](#output\_db\_cluster\_username) | n/a |
| <a name="output_db_instance_identifier"></a> [db\_instance\_identifier](#output\_db\_instance\_identifier) | n/a |
| <a name="output_db_param_group_name"></a> [db\_param\_group\_name](#output\_db\_param\_group\_name) | n/a |
<!-- END_TF_DOCS -->
