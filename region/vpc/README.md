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
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 2.59.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_route.rfc1918_route_10](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | A list of the VPC's availability zones | `list(string)` | n/a | yes |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | The Capsule environment this VPC will belong to | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | The Capsule team that owns this VPC | `string` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The base CIDR block of the VPC; all subnets must be contained within this CIDR range. | `string` | n/a | yes |
| <a name="input_clusters"></a> [clusters](#input\_clusters) | A list of Kube clusters to assign to this VPC | `list(string)` | n/a | yes |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | A list of CIDR blocks that will form the database subnets | `list(string)` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Specifies DNS name for DHCP options set | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of your VPC | `string` | n/a | yes |
| <a name="input_nat_count"></a> [nat\_count](#input\_nat\_count) | The number of EIPs to assign to the NAT | `number` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of CIDR blocks that will form the private subnets | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | A list of CIDR blocks that will form the public subnets | `list(string)` | n/a | yes |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | A transit gateway ID to assign to the AWS Route | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | n/a |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | n/a |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | n/a |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | n/a |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | n/a |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | n/a |
<!-- END_TF_DOCS -->