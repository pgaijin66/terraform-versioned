# Lambda Function

## Overview

This module creates and manages an AWS Lambda function for serverless compute. There are multiple ways to store the code a Lambda will execute--for this module, we chose to standardize on using a Docker image stored in AWS Elastic Container Registry (ECR).

* Slide presentation on [creating Lambdas using this module](https://docs.google.com/presentation/d/1256H2is3gYAwKM4k1oloSWT4v9OZDOGCsC3DtTWuRZg)
* [Video demo of the module](https://www.youtube.com/watch?v=pZDmCI3MZL0) using the [lambda-test](https://github.com/CapsuleHealth/lambda-test) example repo

## Usage Examples

Further examples are available in the tests for this module: [examples.tf](../../tests/lambda/examples.tf).

Example to create a basic Lambda:

```hcl
module "test_basic_lambda" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/lambda"

  name        = "test_basic_lambda"
  image_uri   = "874873923888.dkr.ecr.us-east-1.amazonaws.com/lambda-promtail:latest"
  memory_size = 128
  timeout     = 30

  capsule_service = "testservice"
  capsule_env     = "test"
  capsule_team    = "sre-test"

  vanta_description      = "None"
  vanta_user_data        = false
  vanta_user_data_stored = false
  vanta_contains_ephi    = false
```

---

## FAQ / Common problems

### encrypting secrets with sops

If your Lambda needs secrets that aren't already in Secrets Manager, this module can create them from a local JSON file encrypted with `sops`.

To use SOPS with the Lambda module, the SOPS provider needs to be declared in a `terraform-config.tf` file located in the same directory as the module.

Example terraform-config.tf:

```hcl
terraform {
  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "~> 0.6.0"
    }
  }
}
provider "sops" {}
```

You can then instantiate a `sops_file` data resource anywhere, like such:

```hcl
data "sops_file" "secret_file_for_terraform" {
  source_file = "${path.module}/some_file_encrypted_with_sops.json"
}
```

SOPS supports several common file formats, but for creating secrets with this module we decided to standardize on using JSON.

Encrypt SOPS files how you usually would with Helm secrets.

A full working example of this can be found [here](https://github.com/CapsuleHealth/terraform-module-swe-example/tree/master/terraform/prod/rds/us-east-1).

---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                       | Version  |
| ---------------------------------------------------------- | -------- |
| <a name="requirement_sops"></a> [sops](#requirement\_sops) | ~> 0.6.0 |

## Providers

| Name                                                 | Version  |
| ---------------------------------------------------- | -------- |
| <a name="provider_aws"></a> [aws](#provider\_aws)    | n/a      |
| <a name="provider_sops"></a> [sops](#provider\_sops) | ~> 0.6.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                 | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_policy.addtl_statements_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                     | resource    |
| [aws_iam_policy.secrets_manager_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                        | resource    |
| [aws_iam_role.base_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                       | resource    |
| [aws_iam_role_policy_attachment.addtl_statements_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_role_policy_attachment.managed_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)               | resource    |
| [aws_iam_role_policy_attachment.secrets_read_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)           | resource    |
| [aws_lambda_event_source_mapping.event_source_mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping)      | resource    |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)                                   | resource    |
| [aws_lambda_permission.allow_cognito](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission)                                 | resource    |
| [aws_secretsmanager_secret.lambda_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret)                        | resource    |
| [aws_secretsmanager_secret_version.lambda_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version)        | resource    |
| [aws_iam_policy_document.secrets_manager_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                   | data source |
| [sops_file.secrets_file](https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file)                                                        | data source |

## Inputs

| Name                                                                                                                                 | Description                                                                                                                                                                          | Type           | Default    | Required |
| ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------- | ---------- | :------: |
| <a name="input_additional_policy_statements"></a> [additional\_policy\_statements](#input\_additional\_policy\_statements)           | A list of additional policy statements to attach to the base role. Statements should be in Terraform map format (e.g. {Action = [], Effect = 'Allow', Resource = '*'})               | `any`          | `[]`       |    no    |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env)                                                                | The environment that the Lambda belongs to. (Required)                                                                                                                               | `string`       | n/a        |   yes    |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service)                                                    | The service that this Lambda belongs to. (Required)                                                                                                                                  | `string`       | n/a        |   yes    |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team)                                                             | The team that the Lambda belongs to. (Required)                                                                                                                                      | `string`       | n/a        |   yes    |
| <a name="input_cognito_arn"></a> [cognito\_arn](#input\_cognito\_arn)                                                                | If enable\_invoke\_from\_cognito is true, this is the ARN or ARN-pattern to allow to invoke this Lambda. (Without it, ANY Cognito userpool in ANY account could invoke this Lambda.) | `string`       | `""`       |    no    |
| <a name="input_dlq_target_arn"></a> [dlq\_target\_arn](#input\_dlq\_target\_arn)                                                     | The ARN of the dead-letter SNS/SQS queue to target.                                                                                                                                  | `string`       | `null`     |    no    |
| <a name="input_enable_invoke_from_cognito"></a> [enable\_invoke\_from\_cognito](#input\_enable\_invoke\_from\_cognito)               | Allows the role created for this Lambda to be invoked by Cognito. Only useful if you're going to be using this Lambda as part of a Cognito userpool. (Default: false)                | `bool`         | `false`    |    no    |
| <a name="input_enable_read_dynamodb"></a> [enable\_read\_dynamodb](#input\_enable\_read\_dynamodb)                                   | Grants the permissions for the Lambda to read from DyanamoDB. (Default: false)                                                                                                       | `bool`         | `false`    |    no    |
| <a name="input_enable_read_kinesis"></a> [enable\_read\_kinesis](#input\_enable\_read\_kinesis)                                      | Grants the permissions for the Lambda to read from Kinesis. (Default: false)                                                                                                         | `bool`         | `false`    |    no    |
| <a name="input_enable_read_msk"></a> [enable\_read\_msk](#input\_enable\_read\_msk)                                                  | Grants the permissions for the Lambda to read from MSK. (Default: false)                                                                                                             | `bool`         | `false`    |    no    |
| <a name="input_enable_read_sqs"></a> [enable\_read\_sqs](#input\_enable\_read\_sqs)                                                  | Grants the permissions for the Lambda to read from SQS. (Default: false)                                                                                                             | `bool`         | `false`    |    no    |
| <a name="input_enable_read_write_s3"></a> [enable\_read\_write\_s3](#input\_enable\_read\_write\_s3)                                 | Grants the permissions for the Lambda to read and write to and from S3. (Default: false)                                                                                             | `bool`         | `false`    |    no    |
| <a name="input_enable_write_lambda_insights"></a> [enable\_write\_lambda\_insights](#input\_enable\_write\_lambda\_insights)         | Grants the permissions for the Lambda to write to Lambda Insights. (Default: false)                                                                                                  | `bool`         | `false`    |    no    |
| <a name="input_env_variables"></a> [env\_variables](#input\_env\_variables)                                                          | A map of environment variables for the Lambda in K,V format                                                                                                                          | `map(any)`     | `null`     |    no    |
| <a name="input_event_source_mapping"></a> [event\_source\_mapping](#input\_event\_source\_mapping)                                   | Enables the creation of an event source mapping for this Lambda. (Default: false)                                                                                                    | `any`          | `{}`       |    no    |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri)                                                                      | The ECR image URI to pull and use. (Required)                                                                                                                                        | `string`       | n/a        |   yes    |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size)                                                                | The amount of memory to assign the Lambda in MB. Must be greater than 128. (Default: 128)                                                                                            | `number`       | `128`      |    no    |
| <a name="input_name"></a> [name](#input\_name)                                                                                       | The name of the Lambda function. (Required)                                                                                                                                          | `string`       | n/a        |   yes    |
| <a name="input_read_secrets"></a> [read\_secrets](#input\_read\_secrets)                                                             | List of ARNs for existing Secrets Manager secrets the Lambda will be able to read. (Default: [])                                                                                     | `list(string)` | `[]`       |    no    |
| <a name="input_secret_recovery_window_in_days"></a> [secret\_recovery\_window\_in\_days](#input\_secret\_recovery\_window\_in\_days) | Number of days that this Lambda's secrets (if any) will be recoverable if deleted. (Default: 30)                                                                                     | `number`       | `30`       |    no    |
| <a name="input_secrets_file"></a> [secrets\_file](#input\_secrets\_file)                                                             | Relative path to `sops`-encrypted JSON file containing secrets to create for this Lambda. (Default: '')                                                                              | `string`       | `""`       |    no    |
| <a name="input_secrets_manager_path_prefix"></a> [secrets\_manager\_path\_prefix](#input\_secrets\_manager\_path\_prefix)            | Specifies the prefix under which Secrets Manager secrets will be created. (Default: no value -> will prefix secrets with 'lambda/[name of Lambda]/'.                                 | `string`       | `"lambda"` |    no    |
| <a name="input_timeout"></a> [timeout](#input\_timeout)                                                                              | The amount of time the Lambda has to run the function in seconds. (Default: 3)                                                                                                       | `number`       | `3`        |    no    |
| <a name="input_vanta_contains_ephi"></a> [vanta\_contains\_ephi](#input\_vanta\_contains\_ephi)                                      | Vanta specific tag to specify if the resource contains PHI - true or false (Required)                                                                                                | `bool`         | n/a        |   yes    |
| <a name="input_vanta_description"></a> [vanta\_description](#input\_vanta\_description)                                              | Vanta specific tag to specify the purpose of resource - string value (Required)                                                                                                      | `string`       | n/a        |   yes    |
| <a name="input_vanta_user_data"></a> [vanta\_user\_data](#input\_vanta\_user\_data)                                                  | Vanta specific tag to specify if the resource will contain user data - true or false (Required)                                                                                      | `bool`         | n/a        |   yes    |
| <a name="input_vanta_user_data_stored"></a> [vanta\_user\_data\_stored](#input\_vanta\_user\_data\_stored)                           | Vanta specific tag to specify the type of data the resource transacts/stores - string value (Required)                                                                               | `string`       | n/a        |   yes    |
| <a name="input_vpc_security_groups"></a> [vpc\_security\_groups](#input\_vpc\_security\_groups)                                      | List of security group IDs associated with the Lambda function.                                                                                                                      | `list(string)` | `[]`       |    no    |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets)                                                                | List of subnet IDs associated with the Lambda function.                                                                                                                              | `list(string)` | `[]`       |    no    |

## Outputs

| Name                                                                                  | Description                                                                                                   |
| ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| <a name="output_arn"></a> [arn](#output\_arn)                                         | Amazon Resource Name (ARN) identifying your Lambda Function.                                                  |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn)                  | ARN to be used for invoking Lambda Function - to be used in `aws_api_gateway_integration`'s uri, among others |
| <a name="output_name"></a> [name](#output\_name)                                      | The name of the Lambda function. (Required)                                                                   |
| <a name="output_qualified_arn"></a> [qualified\_arn](#output\_qualified\_arn)         | ARN identifying your Lambda Function Version (if versioning is enabled via publish = true).                   |
| <a name="output_signing_job_arn"></a> [signing\_job\_arn](#output\_signing\_job\_arn) | ARN of the signing job.                                                                                       |
| <a name="output_version"></a> [version](#output\_version)                             | Latest published version of your Lambda Function.                                                             |
<!-- END_TF_DOCS -->