# RDS Provisioned Instance Read Replica


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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The amount of storage, in gibibytes (GiB), to allocate for the RDS Read Replica. If source\_database\_identifier is set, the value is ignored during the creation of the Read Replica. | `number` | `null` | no |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Whether to allow major version upgrades for the RDS Read Replica. If not specified, value is `true` if `capsule_env != production` else `false`. | `bool` | `null` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Changes are ignored until the maintainence window if apply\_immediately is set to `false` | `bool` | `true` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Whether to apply minor version upgrades automatically for the RDS Read Replica | `bool` | `true` | no |
| <a name="input_auto_shutdown"></a> [auto\_shutdown](#input\_auto\_shutdown) | Tag that enables auto shutdown for the Read Replica during off-hours, performed by the startRDS/stopRDS Lambdas. If not specified, Defaults to true for dev, false otherwise. | `bool` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability zone to use for the RDS Read Replica | `string` | `""` | no |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | Environment that the RDS Read Replica is in | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | Service that uses the RDS Read Replica | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | Team that maintains the RDS Read Replica | `string` | n/a | yes |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether to enable deletion protection for the RDS Read Replica. Value is `true` when `capsule_env == production` else `false` (can be overriden). | `bool` | `false` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of enabled cloudwatch logs exports | `list(string)` | `[]` | no |
| <a name="input_existing_param_group_name"></a> [existing\_param\_group\_name](#input\_existing\_param\_group\_name) | -------------# param group # -------------# | `string` | `""` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | RDS instance class to use | `string` | n/a | yes |
| <a name="input_iops"></a> [iops](#input\_iops) | Amount of IOPS to provision for the RDS Read Replica, used only when `storage_type == io1` | `number` | `0` | no |
| <a name="input_legacy_identifier"></a> [legacy\_identifier](#input\_legacy\_identifier) | Legacy identifier for the RDS Read Replica, should only be used when migrating an existing Read Replica over | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window to use for the RDS Read Replica | `string` | `"sun:06:00-sun:06:30"` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Whether to use a multi-AZ deployment for the RDS Read Replica. Default: `true` if `capsule_env == production` else `false` (can be overriden). | `bool` | `false` | no |
| <a name="input_option_group_name"></a> [option\_group\_name](#input\_option\_group\_name) | Name of the option group to use for the RDS Read Replica | `string` | `""` | no |
| <a name="input_param_group_family"></a> [param\_group\_family](#input\_param\_group\_family) | n/a | `string` | `""` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_port"></a> [port](#input\_port) | Port to use for the RDS Read Replica | `string` | `"5432"` | no |
| <a name="input_read_replica_suffix"></a> [read\_replica\_suffix](#input\_read\_replica\_suffix) | n/a | `string` | `"read-replica"` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Whether to skip the final snapshot after the RDS Read Replica is deleted | `bool` | `false` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Snapshot identifier to use for the RDS Read Replica | `string` | `""` | no |
| <a name="input_source_database_identifier"></a> [source\_database\_identifier](#input\_source\_database\_identifier) | Identifier of the primary RDS instance that this Read Replica is going to follow | `string` | n/a | yes |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Storage type to use for the RDS Read Replica | `string` | `"gp2"` | no |
| <a name="input_vanta_contains_ephi"></a> [vanta\_contains\_ephi](#input\_vanta\_contains\_ephi) | Vanta specific tag to specify if the resource contains electronic protected health information (ePHI) | `bool` | `false` | no |
| <a name="input_vanta_description"></a> [vanta\_description](#input\_vanta\_description) | Vanta specific tag to specify the purpose of resource | `string` | `"RDS RR Service"` | no |
| <a name="input_vanta_nonprod"></a> [vanta\_nonprod](#input\_vanta\_nonprod) | Vanta specific tag to indicate if the resource is non-prod | `bool` | `true` | no |
| <a name="input_vanta_owner"></a> [vanta\_owner](#input\_vanta\_owner) | Vanta specific tag to identify resource owner | `string` | `"Global"` | no |
| <a name="input_vanta_user_data"></a> [vanta\_user\_data](#input\_vanta\_user\_data) | Vanta specific tag to specify if the resource will contain user data | `bool` | `false` | no |
| <a name="input_vanta_user_data_stored"></a> [vanta\_user\_data\_stored](#input\_vanta\_user\_data\_stored) | Vanta specific tag to specify the type of data the resource transacts/stores | `string` | `"None"` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | IDs of the VPC security groups to apply to the RDS Read Replica | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
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
<!-- END_TF_DOCS -->