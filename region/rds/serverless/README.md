# RDS Serverless

Pleae pre-read this [FAQ](../README.md) for how to set up your Database password and other common RDS features

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rds_serverless"></a> [rds\_serverless](#module\_rds\_serverless) | terraform-aws-modules/rds-aurora/aws | ~> 5.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_db_parameter_group.serverless](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_rds_cluster_parameter_group.serverless](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_security_group.serverless](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cidr_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.security_group_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | CIDR blocks that are allowed to connect to the cluster | `list(string)` | `[]` | no |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | Security groups that are allowed to connect to the cluster | `list(string)` | `[]` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Whether to apply Database modifications immediately | `bool` | `true` | no |
| <a name="input_auto_pause"></a> [auto\_pause](#input\_auto\_pause) | Whether to allow pausing the cluster when there is no activity | `bool` | `true` | no |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | Name of the environment that this DB relates to. Used for the `capsule:environment` tag. | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | Name of the service this DB relates to. Used for the `capsule:service` tag and part of the instance naming. | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | Name of the team that this DB relates to. Used for the `capsule:team` tag. | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name for an automatically created database on cluster creation. If `null`, `service_name` is used instead. | `string` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether to enable deletion protection for the RDS instance. Value is `true` when `capsule_env = production` | `bool` | `false` | no |
| <a name="input_engine_major_version"></a> [engine\_major\_version](#input\_engine\_major\_version) | Aurora Postgres engine major version - used only for the Parameter Group family Default: `"13"` | `string` | `"13"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Aurora Postgres engine version. Must be in the format of `<major>.<minor>`. Default: "13.9". | `string` | `"13.9"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type to use at master instance. | `string` | n/a | yes |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | The max capacity that the server can scale to. Valid capacity values are (`2`, `4`, `8`, `16`, `32`, `64`, `192`, and `384`). | `number` | n/a | yes |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Starting capacity of the server. Valid capacity values are (`2`, `4`, `8`, `16`, `32`, `64`, `192`, and `384`). Defaults to `2` | `number` | `2` | no |
| <a name="input_password"></a> [password](#input\_password) | Master DB password. At least 8 printable ASCII characters. Can't contain any of the following: / (slash), '(single quote), "(double quote) and @ (at sign). | `string` | n/a | yes |
| <a name="input_seconds_until_auto_pause"></a> [seconds\_until\_auto\_pause](#input\_seconds\_until\_auto\_pause) | The time, in seconds, before the DB cluster is paused. Valid values are 300 through 86400. Defaults to 300 | `number` | `300` | no |
| <a name="input_subnet_group"></a> [subnet\_group](#input\_subnet\_group) | The existing subnet group name to use | `string` | n/a | yes |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | Master DB username | `string` | `null` | no |
| <a name="input_vanta_contains_ephi"></a> [vanta\_contains\_ephi](#input\_vanta\_contains\_ephi) | Vanta specific tag to specify if the resource contains electronic protected health information (ePHI) | `bool` | `false` | no |
| <a name="input_vanta_description"></a> [vanta\_description](#input\_vanta\_description) | Vanta specific tag to specify the purpose of resource | `string` | `"RDS Serverless Service"` | no |
| <a name="input_vanta_nonprod"></a> [vanta\_nonprod](#input\_vanta\_nonprod) | Vanta specific tag to indicate if ther resource is non-prod | `bool` | `true` | no |
| <a name="input_vanta_owner"></a> [vanta\_owner](#input\_vanta\_owner) | Vanta specific tag to identify resource owner | `string` | `"Global"` | no |
| <a name="input_vanta_user_data"></a> [vanta\_user\_data](#input\_vanta\_user\_data) | Vanta specific tag to specify if the resource will contain user data | `bool` | `false` | no |
| <a name="input_vanta_user_data_stored"></a> [vanta\_user\_data\_stored](#input\_vanta\_user\_data\_stored) | Vanta specific tag to specify the type of data the resource transacts/stores | `string` | `"None"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of VPC security groups to associate to the cluster in addition to the SG we create in this module | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
