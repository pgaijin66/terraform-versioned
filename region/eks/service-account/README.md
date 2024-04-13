## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role.cluster_role](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.cluster_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_role.role](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.role_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_service_account.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | Annotations to be included within the serivce account metadata | `map(string)` | `{}` | no |
| <a name="input_cluster_role_api_groups"></a> [cluster\_role\_api\_groups](#input\_cluster\_role\_api\_groups) | API groups to be applied to custom role | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_cluster_role_resources"></a> [cluster\_role\_resources](#input\_cluster\_role\_resources) | Resource types that a cluster role is allowed to manage. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_cluster_role_verbs"></a> [cluster\_role\_verbs](#input\_cluster\_role\_verbs) | Actions that cluster role is allowed to perform | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_create_cluster_role"></a> [create\_cluster\_role](#input\_create\_cluster\_role) | Whether to create a new cluster role for the service account | `bool` | `false` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Whether to create a new role for the service account | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace to create service account | `string` | `""` | no |
| <a name="input_role_api_groups"></a> [role\_api\_groups](#input\_role\_api\_groups) | API groups to be applied to custom role | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_role_resources"></a> [role\_resources](#input\_role\_resources) | Resource types that a role is allowed manage. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_role_verbs"></a> [role\_verbs](#input\_role\_verbs) | Actions that role is allowed to perform | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of service account | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sa_name"></a> [sa\_name](#output\_sa\_name) | n/a |
| <a name="output_sa_secret_name"></a> [sa\_secret\_name](#output\_sa\_secret\_name) | n/a |
