## Usage
To use this module, you will need to provide 4 main inputs: `lambda_arns`, `definition_template_file`, `definition_template_vars`, `step_function_workflow_type`, and `name`. (If you've already used the [API Gateway Module](../apigateway/), this should be sounding familiar.)

The `definition_template_file` variable is the path to an Amazon States Language (ASL) definition file for your Workflow. You are able to use the syntax `${var_name}` within the file to template out a certain variable, and then set `var_name` in the `api_template_vars` map to have it replaced in the `definition_template_file` before execution.

The `lambda_arns` variable is used to give access to `lambda:InvokeFunction` against all relevant Lambdas to your Step Function Workflow. **If it isn't defined, or if it doesn't contain all of the Lambdas necessary, then your Workflow will be unable to execute some of its Lambdas!** We generally recommend either using a `data` block (as depicted below in the example) to get the ARNs, or (much less preferred) manually copypasting into the list of ARNs.

The `name` variable is used to define the name of your Step Function Workflow, and is interpolated as such: `"${var.name}-${var.capsule_env}-sfn"`. (This means, for example, if your step function `name` is `checkout` and you're in `staging`, the final name of the Workflow created will be `checkout-staging-sfn`).

## Generating a Amazon States Language (ASL) JSON file

We rely extensively on defining Step Functions through the use of ASL or [Amazon States Languages](https://states-language.net/spec.html)
JSON files to define step functions and their relationships. Due to the complex nature of this DSL, we highly suggest
using the AWS Console to generate ASL files and copy/pasting the ASL file into the template file rather than creating 
these files manually. You may generate them here: 
https://console.aws.amazon.com/states/


## Example

```json
// File: example.asl.json
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "HelloWorld",
  "States": {
    "HelloWorld": {
      "Type": "Task",
      "Resource": "${hello_lambda_arn}",
      "End": true
    }
  }
}
```

```hcl
data "aws_lambda_function" "some_example_lambda" {
  function_name = "some-example-lambda-name"
}

module "sfn_test" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/stepfunctions"

  name = "test_sfn"
  lambda_arns = [
    data.aws_lambda_function.some_example_lambda.arn,
  ]
  definition_template_file = "./example.asl.json"
  definition_template_vars = {
    hello_lambda_arn = data.aws_lambda_function.some_example_lambda.arn
  }
  step_function_workflow_type = "STANDARD"

  capsule_env     = local.environment
  capsule_team    = local.team
  capsule_service = local.service

  vanta_owner            = local.team
  vanta_description      = "Test stepfunctions tf module"
  vanta_user_data        = false
  vanta_user_data_stored = ""
  vanta_contains_ephi    = false
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.role_for_step_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.sfn_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_sfn_state_machine.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.sfn_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.definition](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | The environment this Step Function Workflow belongs to (dev, staging, production). | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | The service that owns this Step Function Workflows. | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | The team that owns this Step Function Workflow. | `string` | n/a | yes |
| <a name="input_definition_template_file"></a> [definition\_template\_file](#input\_definition\_template\_file) | Relative path to the Amazon States Language (ASL) template file (See https://docs.aws.amazon.com/step-functions/latest/dg/concepts-amazon-states-language.html for more information). You can substitute in variables with `definition_template_vars`. | `string` | n/a | yes |
| <a name="input_definition_template_vars"></a> [definition\_template\_vars](#input\_definition\_template\_vars) | Variables required in the Step Functions definition template file | `map(string)` | `{}` | no |
| <a name="input_lambda_arns"></a> [lambda\_arns](#input\_lambda\_arns) | A list of ALL Lambda ARNs you want this Step Function Workflow - these must be set even if you specify them in the `definition_template_file`, as this argument is used (in part) to generate a role to allow executing against these Lambdas. Consider using `data aws_lambda_function` objects to look these up by name, if necessary. | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Step Function workflow. Will be appended with the environment name. | `any` | n/a | yes |
| <a name="input_step_function_logging_include_execution_data"></a> [step\_function\_logging\_include\_execution\_data](#input\_step\_function\_logging\_include\_execution\_data) | Determines whether execution data is included in your log. When set to false, data is excluded. | `bool` | `true` | no |
| <a name="input_step_function_logging_level"></a> [step\_function\_logging\_level](#input\_step\_function\_logging\_level) | Defines which category of execution history events are logged. Valid values: ALL, ERROR, FATAL, OFF. | `string` | `"ALL"` | no |
| <a name="input_step_function_logging_retention_in_days"></a> [step\_function\_logging\_retention\_in\_days](#input\_step\_function\_logging\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `30` | no |
| <a name="input_step_function_workflow_type"></a> [step\_function\_workflow\_type](#input\_step\_function\_workflow\_type) | The Step Function Workflow Type to use for this Step Function Workflow. See https://docs.aws.amazon.com/step-functions/latest/dg/concepts-standard-vs-express.html for the distinctions. Must be 'STANDARD' or 'EXPRESS'. | `string` | n/a | yes |
| <a name="input_vanta_contains_ephi"></a> [vanta\_contains\_ephi](#input\_vanta\_contains\_ephi) | Vanta specific tag to specify if the resource contains PHI - true or false | `bool` | n/a | yes |
| <a name="input_vanta_description"></a> [vanta\_description](#input\_vanta\_description) | Vanta specific tag to specify the purpose of resource - string value | `string` | n/a | yes |
| <a name="input_vanta_owner"></a> [vanta\_owner](#input\_vanta\_owner) | Vanta specific tag to identify resource owner - string (defaults to same as capsule\_team) | `string` | `null` | no |
| <a name="input_vanta_user_data"></a> [vanta\_user\_data](#input\_vanta\_user\_data) | Vanta specific tag to specify if the resource will contain user data - true or false | `bool` | n/a | yes |
| <a name="input_vanta_user_data_stored"></a> [vanta\_user\_data\_stored](#input\_vanta\_user\_data\_stored) | Vanta specific tag to specify the type of data the resource transacts/stores - string value | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | AWS Step Function State Machine arn |
| <a name="output_name"></a> [name](#output\_name) | AWS Step Function State Machine name |
<!-- END_TF_DOCS -->
