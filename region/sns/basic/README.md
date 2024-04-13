## Usage

To use this module one needs to declare a module block where the source will be this git repo and folder. The module will create an SNS topic, with encryption turned on. The module accepts a few input variables, which are documented below.

The module requires the user to provide a topic name and standard Capsule tags.

The module supports allows both standard and FIFO topics to be created. This is controlled via the `fifo_topic` variable. For FIFO queues it's possible to turn on content based deduplication by setting the corresponding variable to `true`.

## Examples

Basic topic:

```hcl
module example_sns_topic {
  source = "github.com/capsulehealth/terraform-modules-sre/region/sns/basic"

  name            = "capsule-test-topic"
  capsule_env     = "staging"
  capsule_team    = "my-team"
  capsule_service = "my-service"
}
```

Public bucket:

```hcl
module example_fifo_sns_topic {
  source = "github.com/capsulehealth/terraform-modules-sre/region/sns/basic"

  name            = "capsule-test-topic.fifo"
  fifo_topic      = true
  capsule_env     = "staging"
  capsule_team    = "my-team"
  capsule_service = "my-service"
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
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | The environment that this bucket will be deployed into (dev, staging, production) | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | The name of the service that this bucket will be associated with | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | The name of the team that this bucket will be associated with | `string` | n/a | yes |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Whether to enable content-based deduplication for FIFO topics | `bool` | `false` | no |
| <a name="input_fifo_topic"></a> [fifo\_topic](#input\_fifo\_topic) | Whether the topic created should be FIFO | `bool` | `false` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK. We highly recommend not changing this value | `string` | `"alias/sns-sqs"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the SNS topic to create | `string` | n/a | yes |
| <a name="input_vanta_contains_ephi"></a> [vanta\_contains\_ephi](#input\_vanta\_contains\_ephi) | Vanta specific tag to specify if the resource contains PHI - true or false | `bool` | n/a | yes |
| <a name="input_vanta_description"></a> [vanta\_description](#input\_vanta\_description) | Vanta specific tag to specify the purpose of resource - string value | `string` | n/a | yes |
| <a name="input_vanta_owner"></a> [vanta\_owner](#input\_vanta\_owner) | Vanta specific tag to identify resource owner - string | `string` | n/a | yes |
| <a name="input_vanta_user_data"></a> [vanta\_user\_data](#input\_vanta\_user\_data) | Vanta specific tag to specify if the resource will contain user data - true or false | `bool` | n/a | yes |
| <a name="input_vanta_user_data_stored"></a> [vanta\_user\_data\_stored](#input\_vanta\_user\_data\_stored) | Vanta specific tag to specify the type of data the resource transacts/stores - string value | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | n/a |
| <a name="output_sns_topic_id"></a> [sns\_topic\_id](#output\_sns\_topic\_id) | n/a |
<!-- END_TF_DOCS -->
