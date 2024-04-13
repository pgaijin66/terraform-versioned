## Usage

This module adds autoscaling to an existing `dynamodb/simple` table. You can set read/write min and
max capacity for scaling, and specify a target utilization percentage.

**WARNING!!!** This module only works with `PROVISIONED` DynamoDB table types. See the below
example for how to use this module.

## Examples

You MUST create a table with a `PROVISIONED` billing mode. Otherwise, autoscaling will fail:

```hcl
module "example_dynamodb_table_provisioned" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/dynamodb/simple"

  hash_key        = "my_key"
  billing_mode    = "PROVISIONED"  # This MUST be set!
  read_capacity   = 20
  write_capacity  = 10
  capsule_env     = "staging"
  capsule_team    = "my-team"
  capsule_service = "my-service"
}

# This adds autoscaling to the table defined above
module "example_dynamo_table_autoscaler" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/dynamodb/autoscaler"

  table_name = module.example_dynamodb_table_provisioned.table_name

  min_read_capacity       = 5
  max_read_capacity       = 20
  read_target_utilization = 75  # DDB will try to keep utilization of read capacity at 75%

  min_write_capacity       = 5
  max_write_capacity       = 10
  write_target_utilization = 90  # DDB will try to keep utilization of write capacity at 90%

  depends_on = [module.example_dynamodb_table_provisioned]
}
```

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
| [aws_appautoscaling_policy.read_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.write_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.read_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_appautoscaling_target.write_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_dynamodb_table.table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/dynamodb_table) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_max_read_capacity"></a> [max\_read\_capacity](#input\_max\_read\_capacity) | The maximum read capacity units when scaling | `number` | n/a | yes |
| <a name="input_max_write_capacity"></a> [max\_write\_capacity](#input\_max\_write\_capacity) | The maximum write capacity units when scaling | `number` | n/a | yes |
| <a name="input_min_read_capacity"></a> [min\_read\_capacity](#input\_min\_read\_capacity) | The minimum read capacity units when scaling | `number` | n/a | yes |
| <a name="input_min_write_capacity"></a> [min\_write\_capacity](#input\_min\_write\_capacity) | The minimum write capacity units when scaling | `number` | n/a | yes |
| <a name="input_read_target_utilization"></a> [read\_target\_utilization](#input\_read\_target\_utilization) | The read capacity target utilization, expressed as a percentage. AWS will scale up/down to keep utilization close to this percentage | `number` | n/a | yes |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | The NAME of the DynamoDB table to apply the autoscaling policy to | `string` | n/a | yes |
| <a name="input_write_target_utilization"></a> [write\_target\_utilization](#input\_write\_target\_utilization) | The write capacity target utilization, expressed as a percentage. AWS will scale up/down to keep utilization close to this percentage | `number` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
