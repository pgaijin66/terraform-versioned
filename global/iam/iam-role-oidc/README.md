# iam-role-oidc module

Module that creates an IAM Role for (kubernetes) Service Accounts (IRSA) with ABAC permissions and the policy for resources that the service account should be able to access.
There are 3 classifications for the the policy permissions: ABAC, RBAC (non-ABAC) and Misc.

## Examples

**NOTE:** The resultant role name is interpolated by combining the `capsule_*` and `name` keys, which gives the added flexibility to have different roles for different service components instead of one catchall. Below are examples for the role name:

- Service key `foo-api` and name key ommitted: `<capsule_service_name>-<capsule_env>` == `foo-api-staging`
- Service key `foo` and name key `api`: `<capsule_service_name>-<name>-<capsule_env>` == `foo-api-staging`
- Service key `foo` and name key `consumer`: `<capsule_service_name>-<name>-<capsule_env>` == `foo-consumer-staging`

### Basic IAM Role for k8s Serivce Account (IRSA) for an ABAC-only policy

The following example shows how to create a role that will have access to all resources that have matching tag attributes, with the ability to perform the actions listed.

```hcl
module "test_role" {
  source                        = "github.com/capsulehealth/terraform-modules-sre/global/iam/iam-role-oidc"
  name                          = "test-role"
  cluster_names                 = ["devtest"]
  capsule_env                   = "staging"
  capsule_team                  = "sre"
  capsule_service               = "test-service"
  oidc_fully_qualified_subjects = ["system:serviceaccount:test:test"]

  # SNS and RDS support ABAC
  abac_actions = [
    {
      actions = ["sns:Publish"]
    },
    {
      actions = ["rds:CreateDBInstance"]
    }
  ]

  role_description   = "Test IRSA role for testing tests"
  policy_description = "Test policy for test resources"
}
```

### IRSA Role with ABAC, RBAC and Additional permissions

```hcl
module "test_role_two" {
  source                        = "github.com/capsulehealth/terraform-modules-sre/global/iam/iam-role-oidc"
  name                          = "test-role-two"
  cluster_names                 = ["devtest"]
  capsule_env                   = "staging"
  capsule_team                  = "sre"
  capsule_service               = "test-service-two"
  oidc_fully_qualified_subjects = ["system:serviceaccount:test-two:test-two"]

  # SNS and RDS support ABAC
  abac_actions = [
    {
      actions = ["sns:Publish"]
    },
    {
      actions = ["rds:CreateDBInstance"]
    }
  ]

  # RBAC policies (this service uses 2 of the 5 resources that require RBAC)
  rbac_actions_dynamodb     = true
  rbac_actions_s3           = true

  additional_actions = [{
    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:us-east-1:444455556666:queue-foo"]
  }]

  role_description   = "Test IRSA role for testing tests"
  policy_description = "Test policy for test resources"
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.63 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) |
| [aws_eks_clusters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_clusters) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |
| [aws_partition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| abac_actions                  | List of actions that this service should be able to perform on resources it has access to. Should consist of an action block for each resources type (eg rds, sns, etc) | <pre>list(object({<br>    actions = list(string)<br>  }))</pre> | `[]` | no |
| additional_actions            | Additional actions that the service should be able to perform on resources not owned by the service/team. | <pre>list(object({<br>    actions   = list(string)<br>    resources = list(string)<br>  }))</pre> | `[]` | no |
| additional_conditional_actions | Additional actions including Conditions (if not adding Conditions, use additional\_actions instead) | <pre>list(object({<br>    actions   = list(string)<br>    resources = list(string)<br>    conditions = list(object({<br>      test     = string<br>      variable = string<br>      values   = list(string)<br>  })) }))</pre> | `[]` | no |
| assume_role_for_aws_services  | List of AWS services that will be added to the trust policy so they can assume this OIDC role - to avoid having to create yet another role. If specified, should be a list of AWS services (eg. transfer.amazonaws.com) | `list(string)` | `[]` | no |
| aws_account_id                | Account ID where the role should be created. If not set will default to the account that iam caller creating the role belongs to | `string` | `""` | no |
| capsule_env                   | environment that the role will be used in | `string` | n/a | yes |
| capsule_service               | Service that will use the role | `string` | n/a | yes |
| capsule_team                  | Team that maintains the service using the role | `string` | n/a | yes |
| cluster_names                 | Name of the EKS cluster containing the service account | `list(string)` | `[]` | no |
| name                          | Name for the role. | `string` | `""` | no |
| oidc_fully_qualified_subjects | list of fully qualified subjects that can assume the role | `list(any)` | `[]` | no |
| oidc_subjects_with_wildcards  | List of subjects with wildcards that can assume the role | `list(any)` | `[]` | no |
| policy_description            | Description of the policy | `string` | `""` | no |
| rbac_actions_dynamodb         | Does this service use DynamoDB? If so, a special RBAC policy will be crafted" | `bool` | false | no |
| rbac_actions_kafkaconnect     | Does this service use KafkaConnect? If so, a special RBAC policy will be crafted" | `bool` | false | no |
| rbac_actions_lambda           | Does this service use Lambda? If so, a special RBAC policy will be crafted" | `bool` | false | no |
| rbac_actions_s3               | Does this service use s3? If so, a special RBAC policy will be crafted" | `bool` | false | no |
| rbac_actions_sqs              | Does this service use SQS? If so, a special RBAC policy will be crafted" | `bool` | false | no |
| role_description              | Description of the roles purpose | `string` | `""` | no |
| role_path                     | IAM path for the role | `string` | `"/"` | no |

## Outputs

| Name | Description |
|------|-------------|
| oidc_role_arn  | ARN of the oidc role created by this module |
| oidc_role_name | Name of the OIDC role created by this module |
| policy_arn     | ARN of the policy created by this module for accessing resources |
| policy_name    | Name of the policy created by this module for accessing resources |

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
| [aws_iam_policy.this_service_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.oidc_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.oidc_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_clusters.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_clusters) | data source |
| [aws_iam_policy_document.oidc_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this_service_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_abac_actions"></a> [abac\_actions](#input\_abac\_actions) | List of actions that this service should be able to perform on resources it has access to. Should consist of an action block for each resources type (eg rds, sns, etc) | <pre>list(object({<br>    actions = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_additional_actions"></a> [additional\_actions](#input\_additional\_actions) | Additional actions that the service should be able to perform on resources not owned by the service/team. | <pre>list(object({<br>    actions   = list(string)<br>    resources = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_additional_conditional_actions"></a> [additional\_conditional\_actions](#input\_additional\_conditional\_actions) | Additional actions including Conditions (if not adding Conditions, use additional\_actions instead) | <pre>list(object({<br>    actions   = list(string)<br>    resources = list(string)<br>    conditions = list(object({<br>      test     = string<br>      variable = string<br>      values   = list(string)<br>  })) }))</pre> | `[]` | no |
| <a name="input_assume_role_for_aws_services"></a> [assume\_role\_for\_aws\_services](#input\_assume\_role\_for\_aws\_services) | List of AWS services that will be added to the trust policy so they can assume this OIDC role | `list(string)` | `[]` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | Account ID where the role should be created. If not set will default to the account that iam caller creating the role belongs to | `string` | `""` | no |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | Environment that the role will be used in | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | Service that will use the role | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | Team that maintains the service using the role | `string` | n/a | yes |
| <a name="input_cluster_names"></a> [cluster\_names](#input\_cluster\_names) | Name of the EKS cluster containing the service account | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the role | `string` | `null` | no |
| <a name="input_oidc_fully_qualified_subjects"></a> [oidc\_fully\_qualified\_subjects](#input\_oidc\_fully\_qualified\_subjects) | list of fully qualified subjects that can assume the role | `list(any)` | `[]` | no |
| <a name="input_oidc_subjects_with_wildcards"></a> [oidc\_subjects\_with\_wildcards](#input\_oidc\_subjects\_with\_wildcards) | List of subjects with wildcards that can assume the role | `list(any)` | `[]` | no |
| <a name="input_policy_description"></a> [policy\_description](#input\_policy\_description) | Descritpion of the policy | `string` | `""` | no |
| <a name="input_rbac_actions_dynamodb"></a> [rbac\_actions\_dynamodb](#input\_rbac\_actions\_dynamodb) | Does this service use DynamoDB? If so, a special RBAC policy will be crafted | `bool` | `false` | no |
| <a name="input_rbac_actions_kafkaconnect"></a> [rbac\_actions\_kafkaconnect](#input\_rbac\_actions\_kafkaconnect) | Does this service use KafkaConnect? If so, a special RBAC policy will be crafted | `bool` | `false` | no |
| <a name="input_rbac_actions_lambda"></a> [rbac\_actions\_lambda](#input\_rbac\_actions\_lambda) | Does this service use Lambda? If so, a special RBAC policy will be crafted | `bool` | `false` | no |
| <a name="input_rbac_actions_s3"></a> [rbac\_actions\_s3](#input\_rbac\_actions\_s3) | Does this service use s3? If so, a special RBAC policy will be crafted | `bool` | `false` | no |
| <a name="input_rbac_actions_sqs"></a> [rbac\_actions\_sqs](#input\_rbac\_actions\_sqs) | Does this service use SQS? If so, a special RBAC policy will be crafted | `bool` | `false` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | Description of the roles purpose | `string` | `""` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | IAM path for the role | `string` | `"/"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_oidc_role_arn"></a> [oidc\_role\_arn](#output\_oidc\_role\_arn) | ARN of the oidc role created by this module |
| <a name="output_oidc_role_name"></a> [oidc\_role\_name](#output\_oidc\_role\_name) | Name of the OIDC role created by this module |
| <a name="output_policy"></a> [policy](#output\_policy) | The policy document (JSON) |
| <a name="output_policy_arn"></a> [policy\_arn](#output\_policy\_arn) | ARN of the policy created by this module for accessing resources |
| <a name="output_policy_name"></a> [policy\_name](#output\_policy\_name) | Name of the policy created by this module for accessing resources |
<!-- END_TF_DOCS -->
