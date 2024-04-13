## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | terraform-aws-modules/eks/aws | 6.0.2 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.vpc_traffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.vpc_traffic_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.vpc_traffic_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Version of the EKS cluster | `string` | n/a | yes |
| <a name="input_cross_vpc_traffic"></a> [cross\_vpc\_traffic](#input\_cross\_vpc\_traffic) | List of CIDRs to allow cross-VPC traffic to | <pre>map(object({<br>    cidr      = string<br>    protocol  = string<br>    from_port = number<br>    to_port   = number<br>  }))</pre> | `{}` | no |
| <a name="input_map_roles"></a> [map\_roles](#input\_map\_roles) | List of roles to grant access to the EKS cluster | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_users"></a> [map\_users](#input\_map\_users) | List of users to grant access to the EKS cluster | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_on_demand_worker_group"></a> [on\_demand\_worker\_group](#input\_on\_demand\_worker\_group) | Configuration for the on-demand worker group | <pre>object({<br>    ami_id               = string<br>    instance_type        = string<br>    asg_min_size         = number<br>    asg_max_size         = number<br>    asg_desired_capacity = number<br>  })</pre> | <pre>{<br>  "ami_id": "",<br>  "asg_desired_capacity": 0,<br>  "asg_max_size": 6,<br>  "asg_min_size": 0,<br>  "instance_type": "m5.xlarge"<br>}</pre> | no |
| <a name="input_spot_worker_group"></a> [spot\_worker\_group](#input\_spot\_worker\_group) | Configuration for the spot worker group | <pre>object({<br>    ami_id               = string<br>    instance_price       = string<br>    instance_type        = string<br>    asg_min_size         = number<br>    asg_max_size         = number<br>    asg_desired_capacity = number<br>  })</pre> | <pre>{<br>  "ami_id": "",<br>  "asg_desired_capacity": 0,<br>  "asg_max_size": 1,<br>  "asg_min_size": 0,<br>  "instance_price": "0.68",<br>  "instance_type": "c5.4xlarge"<br>}</pre> | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | IDs of the subnets to create the EKS cluster in | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to create the EKS cluster in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_oidc_url"></a> [oidc\_url](#output\_oidc\_url) | n/a |

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 17.24.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | The environment that this Cluster will be deployed into (dev, staging, production) | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | The name of the service (team) that this Cluster will be associated with | `string` | `"sre"` | no |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | The name of the team that this Cluster will be associated with | `string` | `"sre"` | no |
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | List of k8s logs to send to cloudwatch | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Restricts access to the api server from inside the VPC only | `bool` | `false` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Allows access to the api server from the internet | `bool` | `true` | no |
| <a name="input_cluster_map_roles"></a> [cluster\_map\_roles](#input\_cluster\_map\_roles) | List of roles to add to the aws-auth configmap | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_cluster_map_users"></a> [cluster\_map\_users](#input\_cluster\_map\_users) | List of users to add to the aws-auth configmap | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_subnets"></a> [cluster\_subnets](#input\_cluster\_subnets) | List of subnets to allocate to the nodes | `list(string)` | `[]` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Version k8s to use when creating the EKS cluster | `string` | `"1.19"` | no |
| <a name="input_fargate_profiles"></a> [fargate\_profiles](#input\_fargate\_profiles) | Map of fargate profiles to create | `any` | `{}` | no |
| <a name="input_kubeconfig_aws_authenticator_additional_args"></a> [kubeconfig\_aws\_authenticator\_additional\_args](#input\_kubeconfig\_aws\_authenticator\_additional\_args) | n/a | `list(string)` | `[]` | no |
| <a name="input_manage_aws_auth"></a> [manage\_aws\_auth](#input\_manage\_aws\_auth) | Creates the aws-auth configmap in kube-system | `bool` | `true` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | List of node groups to create | `any` | `{}` | no |
| <a name="input_node_groups_defaults"></a> [node\_groups\_defaults](#input\_node\_groups\_defaults) | List of defaults for node groups | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to add the cluster | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the EKS cluster will be created | `string` | n/a | yes |
| <a name="input_worker_additional_security_group_ids"></a> [worker\_additional\_security\_group\_ids](#input\_worker\_additional\_security\_group\_ids) | additional security groups to add to worker nodes | `list(string)` | `[]` | no |
| <a name="input_worker_ami_name_filter"></a> [worker\_ami\_name\_filter](#input\_worker\_ami\_name\_filter) | Name filter used for selecting specific ami | `string` | `""` | no |
| <a name="input_worker_ami_name_filter_prefix"></a> [worker\_ami\_name\_filter\_prefix](#input\_worker\_ami\_name\_filter\_prefix) | prefix for filtering EKS amis | `string` | `""` | no |
| <a name="input_worker_groups"></a> [worker\_groups](#input\_worker\_groups) | List of worker node groups to create | `any` | `[]` | no |
| <a name="input_write_aws_auth_config"></a> [write\_aws\_auth\_config](#input\_write\_aws\_auth\_config) | Writes the aws-auth configmap in the terraform apply | `bool` | `false` | no |
| <a name="input_write_kubeconfig"></a> [write\_kubeconfig](#input\_write\_kubeconfig) | Outputs the kubeconfig as part of the terraform apply | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The ARN for your EKS Cluster |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint for your EKS Kubernetes API |
| <a name="output_cluster_iam_role_arn"></a> [cluster\_iam\_role\_arn](#output\_cluster\_iam\_role\_arn) | IAM role ARN of the EKS cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID for your EKS Cluster |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | The OIDC Issuer URL for your EKS Cluster |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | The ARN of the OIDC Provider |
<!-- END_TF_DOCS -->