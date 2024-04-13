# Usage

This module will create a Redis cluster for you, with the name interpolated from the `capsule_env`, `capsule_service`, and optionally `cache_name` (if provided) variables. The naming format is as follows:

```terraform
  name       = var.cache_name != null ? "${var.capsule_service}-${var.cache_name}-${var.capsule_env}" : "${var.capsule_service}-${var.capsule_env}"
```

**Most** users will be perfectly fine leaving out the `cache_name` -- very few services will need multiple Redis caches per service.

Notably, it's advantageous to leave the `cache_name` variable off due to the [AWS-imposed](https://docs.aws.amazon.com/cli/latest/reference/elasticache/create-replication-group.html#options) 40-character limit on redis cluster names.

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
| [aws_elasticache_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.cache_cluster_itself](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cache_name"></a> [cache\_name](#input\_cache\_name) | Unique identifier for the cache. Must contain only alphanumeric characters and hyphens. Only necessary if you need more than one cache per service-env pair, otherwise omit. | `string` | `null` | no |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | Environment this cache is in. e.g. dev, test, prod | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | Service this cache is used for | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | Team that maintains this cache. e.g. sre | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Short form description for this cluster. What is it going to be used for? Helpful for SRE to know. | `string` | n/a | yes |
| <a name="input_enable_failover"></a> [enable\_failover](#input\_enable\_failover) | Whether to use a multi-AZ deployment for the Cluster. Default: `true` if `capsule_env == production` else `false` (can be overriden). | `bool` | `false` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version for the cache. Must be in the format of `<major>.x`. Default: `6.x`. | `string` | `"6.x"` | no |
| <a name="input_family"></a> [family](#input\_family) | The family for the parameter group. Optional, since >6.x the format of the cache engine\_version and param\_group family is different. | `string` | `null` | no |
| <a name="input_final_snapshot"></a> [final\_snapshot](#input\_final\_snapshot) | Take a final snapshot before deleting the instance | `bool` | `true` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Machine type for your cache nodes. See https://aws.amazon.com/elasticache/pricing/ for details. | `string` | n/a | yes |
| <a name="input_number_of_read_replicas"></a> [number\_of\_read\_replicas](#input\_number\_of\_read\_replicas) | Number of read replicas to add to your cluster. Max of 5. If you set this to 0, you will get a cluster with one node. | `number` | n/a | yes |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | List of parameters to set. See https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/ParameterGroups.Redis.html for more information. | `list(map(string))` | `[]` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | SG IDs to add to the new Redis cluster. | `list(string)` | n/a | yes |
| <a name="input_vanta_contains_ephi"></a> [vanta\_contains\_ephi](#input\_vanta\_contains\_ephi) | Vanta specific tag to specify if the resource contains electronic protected health information (ePHI) | `bool` | `false` | no |
| <a name="input_vanta_description"></a> [vanta\_description](#input\_vanta\_description) | Vanta specific tag to specify the type of user data (if any) the resource transacts/stores | `string` | `"Redis Service"` | no |
| <a name="input_vanta_nonprod"></a> [vanta\_nonprod](#input\_vanta\_nonprod) | Vanta specific tag to if resource is non-prod | `bool` | `false` | no |
| <a name="input_vanta_owner"></a> [vanta\_owner](#input\_vanta\_owner) | Vanta specific tag to identify resource owner | `string` | `"Global"` | no |
| <a name="input_vanta_user_data"></a> [vanta\_user\_data](#input\_vanta\_user\_data) | Vanta specific tag to specify if the resource will contain user data | `bool` | `false` | no |
| <a name="input_vanta_user_data_stored"></a> [vanta\_user\_data\_stored](#input\_vanta\_user\_data\_stored) | Vanta specific tag to specify the type of data the resource transacts/stores | `string` | `"Stored Account Information"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
