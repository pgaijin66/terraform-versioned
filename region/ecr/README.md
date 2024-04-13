## How to use

To use this module, define your terraform config file to include the providers listed below. Then, you would need a code block similar to this:

```hcl
module my_ecr_repository {
  source = "github.com/capsulehealth/terraform-modules-sre/region/ecr"

  name            = "my-ecr-repo"
  capsule_team    = "my-team"
  capsule_service = "my-service"
}
```

This will create the ECR repo and add a policy to it. Note that the variables used in the example above are mandatory, and the apply will fail if these variable values are not provided.

If your repo will see frequent pushes, you can add another variable `expire_after_30_days` and set it to `true`. This wil create a policy for your ECR repo that will remove any images older than 30 days. This way, you can avoid creating an extremely large repo over time. This variable is set to false by default.

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
| [aws_ecr_lifecycle_policy.expire_after_thirty_days_keep_latest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.allow_cross_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_iam_policy_document.allow_cross_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | The name of the service that this repo will be associated with | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | The name of the team that this repo will be associated with | `string` | n/a | yes |
| <a name="input_expire_after_30_days"></a> [expire\_after\_30\_days](#input\_expire\_after\_30\_days) | Whether to create a policy that will delete images older than 30 days. Useful for repos that will see frequent updates | `bool` | `false` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Forcefully delete the ECR repository even if it contains images (dangerous) | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to give to the repository | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the created repository |
| <a name="output_name"></a> [name](#output\_name) | The name of the created repository |
| <a name="output_registry_id"></a> [registry\_id](#output\_registry\_id) | The registry ID for the created repository |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | The URL of the created repository |
<!-- END_TF_DOCS -->
