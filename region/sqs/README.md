## Description

Provisions AWS SQS queues.

Queue name is interpolated as:

```hcl
"${var.capsule_service}-[${var.name}-]-${var.capsule_env}"
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
[aws](#providers) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.allow_sns_to_send_messages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_sqs_queue_policy.lambda_interaction_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_sns_to_send_messages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_interaction_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | The environment this queue belongs to (dev, staging, production). | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | The service that owns this SQS queue. | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | The team that owns this SQS queue. | `string` | n/a | yes |
| <a name="input_vanta_contains_ephi"></a> [vanta\_contains\_ephi](#input\_vanta\_contains\_ephi) | Vanta specific tag to specify if the resource contains PHI - true or false | `bool` | n/a | yes |
| <a name="input_vanta_description"></a> [vanta\_description](#input\_vanta\_description) | Vanta specific tag to specify the purpose of resource - string value | `string` | n/a | yes |
| <a name="input_vanta_nonprod"></a> [vanta\_nonprod](#input\_vanta\_nonprod) | Vanta specific tag to if resource is non-prod - true or false | `bool` | n/a | yes |
| <a name="input_vanta_owner"></a> [vanta\_owner](#input\_vanta\_owner) | Vanta specific tag to identify resource owner - string | `string` | n/a | yes |
| <a name="input_vanta_user_data"></a> [vanta\_user\_data](#input\_vanta\_user\_data) | Vanta specific tag to specify if the resource will contain user data - true or false | `bool` | n/a | yes |
| <a name="input_vanta_user_data_stored"></a> [vanta\_user\_data\_stored](#input\_vanta\_user\_data\_stored) | Vanta specific tag to specify the type of data the resource transacts/stores - string value | `string` | n/a | yes |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Whether or not to enable contest based deduplication. | `bool` | `false` | no |
| <a name="input_create_dlq"></a> [create\_dlq](#input\_create\_dlq) | Whether to create a DLQ alongside this SQS queue. | `bool` | `false` | no |
| <a name="input_dlq_arn"></a> [dlq\_arn](#input\_dlq\_arn) | If using an extant DLQ, or one defined by another module, the ARN of the DLQ. If provided, will be used instead of create\_dlq. | `string` | `null` | no |
| <a name="input_dlq_content_based_deduplication"></a> [dlq\_content\_based\_deduplication](#input\_dlq\_content\_based\_deduplication) | Whether or not to enable contest based deduplication for the DLQ. | `bool` | `false` | no |
| <a name="input_dlq_message_retention_seconds"></a> [dlq\_message\_retention\_seconds](#input\_dlq\_message\_retention\_seconds) | The amount of seconds to retain a message in the DLQ. | `number` | `86400` | no |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Whether or not to create a FIFO queue. | `bool` | `false` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK. We highly recommend not changing this value. | `string` | `"alias/sns-sqs"` | no |
| <a name="input_lambda_function_roles"></a> [lambda\_function\_roles](#input\_lambda\_function\_roles) | List of Lambda execution roles to be added to the sqs queue policy | `list(string)` | `null` | no |
| <a name="input_lambda_functions"></a> [lambda\_functions](#input\_lambda\_functions) | List of Lambda function ARNs that are allowed to interact with this queue | `list(string)` | `null` | no |
| <a name="input_lambda_policy"></a> [lambda\_policy](#input\_lambda\_policy) | Whether or not to create a policy for lambda functions to interact with this queue. | `bool` | `false` | no |
| <a name="input_legacy_name"></a> [legacy\_name](#input\_legacy\_name) | Do not use this for new resources, it is reserved for legacy resources that are being migrated, and will be deprecated in the future. | `string` | `null` | no |
| <a name="input_maxReceiveCount"></a> [maxReceiveCount](#input\_maxReceiveCount) | How many times a message will be processed before being moved into the DLQ. | `number` | `null` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | How many times a message will be processed before being moved into the DLQ. | `number` | `1` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | The amount of seconds to retain a message. | `number` | `86400` | no |
| <a name="input_name"></a> [name](#input\_name) | Optional identifier - if specified, will be interpolated into the queue name. | `string` | `null` | no |
| <a name="input_redrive_policy_enabled"></a> [redrive\_policy\_enabled](#input\_redrive\_policy\_enabled) | Whether or not this queue will allow redrive to a DLQ. | `bool` | `false` | no |
| <a name="input_sns_target"></a> [sns\_target](#input\_sns\_target) | Whether this queue will be used as a subscription for an SNS topic. | `bool` | `false` | no |
| <a name="input_sns_topics"></a> [sns\_topics](#input\_sns\_topics) | List of SNS topic ARNs that are allowed to publish to this queue | `list(string)` | `[]` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | The visibility timeout for the queue. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sqs_dlq_arn"></a> [sqs\_dlq\_arn](#output\_sqs\_dlq\_arn) | n/a |
| <a name="output_sqs_dlq_id"></a> [sqs\_dlq\_id](#output\_sqs\_dlq\_id) | n/a |
| <a name="output_sqs_queue_arn"></a> [sqs\_queue\_arn](#output\_sqs\_queue\_arn) | n/a |
| <a name="output_sqs_queue_id"></a> [sqs\_queue\_id](#output\_sqs\_queue\_id) | n/a |
<!-- END_TF_DOCS -->
