# Terraform module for AWS ElasticSearch cluster

The cluster will be placed into the configured VPC and run on private subnets (with a `/19` CIDR).

By default, AWS snapshots the database every hour. This is not configurable.

Furthermore, the data is encrypted at-rest using the ElasticSearch KMS service key (e.g. we don't manage it). Data
is also encrypted in-transit from node-to-node.

## Examples


### Minimal example
```hcl
module "elasticsearch_cluster" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/elasticsearch"

  elasticsearch_version = "7.10"

  capsule_env     = "production"
  capsule_team    = "my-team"
  capsule_service = "my-service"
}
```

### Full example
```hcl
module "elasticsearch_cluster" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/elasticsearch"

  name = "my-elasticsearch-cluster"
  elasticsearch_version = "7.10"

  ebs_volume_type = "io1" # standard, gp2, or io1. Default = gp2
  ebs_volume_size = 100 # GB
  ebs_iops = 1500 # Must be at a 30:1 ratio or less to volume size. Required to be set for provisioned EBS types
  
  iam_actions = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]
  iam_role_arns = ["my_iam_role"] # This module creates roles, but you can specify additional ones to grant permissions to here

  master_node_instance_type = "r5.large.elasticsearch"
  master_node_instance_count = 3 # Recommended 3 in production; cannot be 1. Set to 0 to disable.
  node_instance_type = "r5.large.elasticsearch"
  node_instance_count = 2

  warm_count = 2
  warm_type = "ultrawarm1.large.elasticsearch"
  
  capsule_env     = "production"
  capsule_team    = "my-team"
  capsule_service = "my-service"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticsearch_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) | resource |
| [aws_security_group.office](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_group.vpc_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet_ids.vpc_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | IAM policy document specifying the access policies for the domain | `string` | `null` | no |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | The Capsule environment that this resource will be deployed into (dev, staging, production) | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | The name of the Capsule service that this resource will be associated with | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | The name of the Capsule team that this resource will be associated with | `string` | n/a | yes |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | How many days to retain cluster logs in Cloudwatch. | `number` | `30` | no |
| <a name="input_ebs_iops"></a> [ebs\_iops](#input\_ebs\_iops) | The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type | `number` | `0` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | EBS volumes for data storage in GB | `number` | `100` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | Storage type of EBS volumes | `string` | `"gp2"` | no |
| <a name="input_elasticsearch_version"></a> [elasticsearch\_version](#input\_elasticsearch\_version) | The ElasticSearch version to use | `string` | n/a | yes |
| <a name="input_enable_zone_awareness"></a> [enable\_zone\_awareness](#input\_enable\_zone\_awareness) | Whether or not the domain is aware of other zones. | `bool` | `false` | no |
| <a name="input_iam_actions"></a> [iam\_actions](#input\_iam\_actions) | List of actions to allow for the IAM roles, _e.g._ `es:ESHttpGet`, `es:ESHttpPut`, `es:ESHttpPost` | `list(string)` | <pre>[<br>  "es:ESHttpGet",<br>  "es:ESHttpPut",<br>  "es:ESHttpPost"<br>]</pre> | no |
| <a name="input_iam_role_arns"></a> [iam\_role\_arns](#input\_iam\_role\_arns) | List of IAM role ARNs to permit access to the Elasticsearch domain. This module already creates an IAM role, but you can specify additional ones. | `list(string)` | `[]` | no |
| <a name="input_legacy_log_group_name"></a> [legacy\_log\_group\_name](#input\_legacy\_log\_group\_name) | Do not use this value, it is reserved for legacy resources and will be deprecated in the future. | `string` | `null` | no |
| <a name="input_legacy_name"></a> [legacy\_name](#input\_legacy\_name) | Do not use this value, it is reserved for legacy resources and will be deprecated in the future. | `string` | `null` | no |
| <a name="input_master_node_instance_count"></a> [master\_node\_instance\_count](#input\_master\_node\_instance\_count) | The number of dedicated master node instances to run on the cluster. Set to 0 to disable master nodes | `number` | `null` | no |
| <a name="input_master_node_instance_type"></a> [master\_node\_instance\_type](#input\_master\_node\_instance\_type) | The instance type to use for dedicated master nodes | `string` | `"r5.large.elasticsearch"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to give the ElasticSearch domain that you want to create. By default, there is no name and it will be named {capsule\_service}-{capsule\_env} | `string` | `null` | no |
| <a name="input_node_instance_count"></a> [node\_instance\_count](#input\_node\_instance\_count) | The number of instances to run on the cluster | `number` | `null` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | The instance type to use for scaling nodes in the cluster | `string` | `"r5.large.elasticsearch"` | no |
| <a name="input_warm_count"></a> [warm\_count](#input\_warm\_count) | The warm node count. Must be between 2 and 150 | `number` | `0` | no |
| <a name="input_warm_type"></a> [warm\_type](#input\_warm\_type) | The warm node type. Must be ultrawarm1.medium.elasticsearch, ultrawarm1.large.elasticsearch, or ultrawarm1.xlarge.elasticsearch | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_arn"></a> [domain\_arn](#output\_domain\_arn) | ARN of the Elasticsearch domain |
| <a name="output_domain_id"></a> [domain\_id](#output\_domain\_id) | Unique identifier for the Elasticsearch domain |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | Name of the Elasticsearch domain |
<!-- END_TF_DOCS -->