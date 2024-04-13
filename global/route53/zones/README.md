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
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone_association.secondary-vpcs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_comment"></a> [comment](#input\_comment) | A descriptor for the hosted zone. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone. | `string` | `"false"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the hosted zone. | `string` | n/a | yes |
| <a name="input_secondary_vpcs"></a> [secondary\_vpcs](#input\_secondary\_vpcs) | List of additional vpc IDs to be associated with this zone. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Define any tags to be associated with this hosted zone. | `map(string)` | `{}` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | The primary vpc to be associated with this zone if it's supposed to be a private one. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | The domain name of the route53 hosted zone. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | A list of name servers in associated (or default) delegation set. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The ID of the hosted zone that is being created. |
<!-- END_TF_DOCS -->