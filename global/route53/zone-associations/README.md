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
| [aws_route53_zone_association.association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | The region of the vpc. | `string` | `""` | no |
| <a name="input_vpcId"></a> [vpcId](#input\_vpcId) | The vpc ID to assciate with the zone. | `string` | n/a | yes |
| <a name="input_zoneId"></a> [zoneId](#input\_zoneId) | The zone ID to associate with the vpc. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The unique ID of the association |
<!-- END_TF_DOCS -->