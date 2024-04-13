# Grafana Cross Account Cloudwatch Read Role

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.grafana_cloudwatch_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.grafana_cloudwatch_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.grafana_cloudwatch_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.grafana_cloudwatch_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.grafana_cloudwatch_read_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| [grafana_roles](./variables.tf) | The list of roles that can assume the Grafana cloudwatch read role | `list(string)` | n/a | yes |
| [capsule_env](./variables.tf) | The environment name | `string` | n/a | yes |
| [capsule_service](./variables.tf) | The name of the service using the role | `string` | n/a | yes |
| [capsule_team](./variables.tf) | The name of the team managing the service | `string` | n/a | yes |
| [grafana_roles](./variables.tf) | The list of roles that can assume the Grafana cloudwatch read role | `list(string)` | n/a | yes |
| [name](./variables.tf) | The name of the IAM role | `string` | `""` | no |

## Outputs

No outputs.
