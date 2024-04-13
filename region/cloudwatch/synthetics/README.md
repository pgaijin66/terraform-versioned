# Terraform module for AWS Synthetics

This module provisions an AWS Synthetics canary that can be used for endpoint monitoring. For more documentation on Synthetics please use the following links:

- [AWS Docs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries.html)
- [SRE discovery](https://capsulerx.atlassian.net/wiki/spaces/devops/pages/1792704539/Cloudwatch+Synthetics)

Currently, this module supports the creation of JS and Python canaries. The canary code has to live in a zip file in the same directory as the terraform file defining the module. It is up to the users of the module to ensure that they have an up-to-date zip file present in their repo. The name of the zip file needs to follow the convention `<capsule_service>-<capsule_env>.zip`. If you provided the optional `var.name`, you will need to then name the zip file `<capsule_service>-<capsule_env>-<name>.zip`. For example, if the `capsule_service` variable for your service is `my-service`, and the `capsule_env` variable is `staging`, then you should ensure that the zip file is named `my-service-staging.zip`. If you also provided the `name` variable as `test1`, you will then need to name the zip file `my-service-staging-test1.zip` Please also note, that the zip file needs to follow a specific structure for AWS Synthetics to be able to use it. For details on how to ensure proper structure, please read the following documentation: https://aws.amazon.com/premiumsupport/knowledge-center/cloudwatch-fix-failing-canary/.

**Please be aware that the canary name may get truncated because of AWS's 21 character limit. In that case, you don't have to do anything extra. However, the name in the AWS console may be a bit wonky. The canary should still be searchable by the full name, as the tag will still use the format listed above.**

Besides specifying the standard capsule tags, the user of this module needs to specify the following variables:

- `handler` defines the entrypoint into the canary. This string needs to end in `handler`, and that function needs to exist in your canary code. Also, the first part of this string needs to be the name of the file where the canary function is defined. For example, if you define your canary in a file named `my-function.js`, the value for `handler` should be `my-function.handler`
- `runtime_version` accepts only two parameters: 
   - for JS canaries, use `syn-nodejs-puppeteer-3.2` . *note*: 3.3 is not supported yet.  
   - For python canaries use `syn-python-selenium-1.0`
- `private_endpoint` is a bool defining whether the function should target endpoints available only inside our VPC, or targets that are externally facing. For example, when targeting a service like `my-service.internal.capsule.com` you will typically need to set this var to `true`. By default it is set to false, and the canary won't work for those types of endpoints. If your endpoint is public, you can omit this value.

There are also optional values:

- `minutes` specifies how often the Canary should run. The default value, if this var is not specified, is every 5 minutes. The range is anywhere between 1 to 59 minutes.
- `secret_value` allows you to create a Secrets Manager object along with your Canary. This var currently accepts a string only, with potential expansion to key-value pairs in the future. For an example of how this is used with a sops encrypted file to store the value in Github, please visit the [tests directory](../../../tests/cloudwatch/synthetics/).
- `secret_recovery_window_in_days` allows you to change the recovery window for the Secrets Manager managed secret. This is especially important to set to `0` in tests that will be regularly spun up and torn down, as AWS will throw an error if we try to spin up a new secret with the same name as one that's deleted but still in recovery window (`(InvalidRequestException) when calling the CreateSecret operation: You can't create this secret because a secret with this name is already scheduled for deletion.`). Defaults to `0`, increase if you need the ability to maybe recover it later.
- `alert_on_failure` allows you to automatically add an alert that will fire to OpsGenie if the Canary success-percentage is too low. This is currently not very configurable, and will be expanded on in the future. (See [the implementation](canary.tf) for more details for now -- this feature is currently in MVP mode.)
- `canary_steps` allows you to provide a list of named steps in your function code to pull metrics for. Providing this value will allow an exporter to pull in per step metrics into Prometheus. If this value is not provided, you will only see metrics about your function in Prometheus.

## Alerts for Failed Canaries
Most canaries should trigger an alert if they are in a failed state. To have your canary trigger alerts you need to make sure you've:

* Defined an appropriate `capsule_team` (see below)
* `alert_on_failure` should be set to `true`
* `alert_queue` should be the default, see below under inputs


### Capsule Teams
Capsule Teams are used to name your canary and any related alerts. For example, for the canary `bff-production-email-check`, the `capsule_team` is set to acquisition. This means that the associated alert is named `[acquisition/bff/production] SyntheticsCanary email-check SuccessPercent less than 90`. When this triggers an OpsGenie alert, the eng on call can easily see which team "owns" this canary. 

Additionally, to determine which OpsGenie response group is alerted for a canary failure, `capsule_team` is hardcoded to map to a specific responder group. This is done [within the OpsGenie settings](https://capsule.app.opsgenie.com/settings/integration/edit/CloudWatch/fc42a0e9-375f-4d05-a70c-d8df54bbdb1a), but only SRE has access to view/edit this. 

The capsule_teams are mapped as follows (as of December 14, 2021):

| capsule_team  | OpsGenie Responder Team  |
|---|---|
| acquisition       | ConsumerWeb_BFF  |
| retention         | ConsumerWeb_BFF  |
| corex             | ConsumerWeb_BFF  |
| ops-workflows     | ops-workflows  |
| pai               | pai  |
| partnerships      | Partnerships_escalation  |
| pharmacy-software | pharmacy-software  |
| post-checkout     | Post Checkout_escalation  |
| pre-checkout      | pre-checkout  |
| sre               | DevOps  |
| workflows         | The Configurables_escalation  |
| vesto             | Vesto_escalation  |
| anything else     | DevOps  |

## Examples

```hcl
module "test_cloudwatch_synthetics_canary" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/cloudwatch/synthetics"

  runtime_version = "syn-nodejs-puppeteer-3.1"
  handler         = "myfile.handler"
  capsule_env     = "staging"
  capsule_team    = "my-team"
  capsule_service = "my-service"
}
```

```hcl
module "test_cloudwatch_synthetics_canary_private" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/cloudwatch/synthetics"

  runtime_version  = "syn-nodejs-puppeteer-3.1"
  handler          = "myfile.handler"
  private_endpoint = true
  capsule_env      = "staging"
  capsule_team     = "my-team"
  capsule_service  = "my-service-private"
}
```

```hcl
module "test_cloudwatch_synthetics_canary" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/cloudwatch/synthetics"

  runtime_version  = "syn-nodejs-puppeteer-3.1"
  handler          = "testing.handler"
  minutes          = 1

  // enable cloudwatch alarm
  alert_on_failure = true

  // configure prometheus alarm
  runbook_url               = "https://foo.internal.capsule.com/super-cool-rb.html"
  alert_eval_period         = "10m"
  success_percent_threshold = "90"

  canary_steps     = ["mystep1", "mystep2"]

  capsule_env      = "staging"
  capsule_team     = "sre"
  capsule_service  = "testing-testing-testing"
}
```

```hcl
module "test_cloudwatch_synthetics_canary_alarm" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/cloudwatch/synthetics"

  runtime_version  = "syn-nodejs-puppeteer-3.1"
  handler          = "myfile.handler"
  private_endpoint = true

  # This means that 2/3 breaching datapoints will trigger the alarm
  # in other words, 2 datapoints in any 3 period window
  alarm_num_datapoints_to_alarm = 2
  alarm_evaluation_periods      = 3
  
  # The period window is 300 seconds
  alarm_period_seconds          = 300
  
  # The threshold is a success rate less than 75%
  alarm_threshold               = 75
  
  capsule_env      = "staging"
  capsule_team     = "my-team"
  capsule_service  = "my-service-private"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_sops"></a> [sops](#requirement\_sops) | ~> 0.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_sops"></a> [sops](#provider\_sops) | ~> 0.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.success_percent_alert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_s3_bucket_object.canary_code](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_secretsmanager_secret.canary_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.canary_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_synthetics_canary.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary) | resource |
| [null_resource.clean_up](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.name_hash](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_s3_bucket.capsule_canary_code](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_subnet_ids.private_vpc_internal_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.vpc_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [sops_file.secrets](https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_evaluation_periods"></a> [alarm\_evaluation\_periods](#input\_alarm\_evaluation\_periods) | The number of periods over which data is compared to the specified threshold | `number` | `3` | no |
| <a name="input_alarm_num_datapoints_to_alarm"></a> [alarm\_num\_datapoints\_to\_alarm](#input\_alarm\_num\_datapoints\_to\_alarm) | The number of datapoints that must be breaching to trigger the alarm | `number` | `3` | no |
| <a name="input_alarm_period_seconds"></a> [alarm\_period\_seconds](#input\_alarm\_period\_seconds) | The period in seconds over which the specified statistic is applied | `number` | `300` | no |
| <a name="input_alarm_threshold"></a> [alarm\_threshold](#input\_alarm\_threshold) | The value against which the specified statistic is compared | `number` | `90` | no |
| <a name="input_alert_on_failure"></a> [alert\_on\_failure](#input\_alert\_on\_failure) | Create a CloudWatch alarm alongside this that will alert if success percent drops below 90 over 300 seconds | `bool` | `false` | no |
| <a name="input_alert_queue"></a> [alert\_queue](#input\_alert\_queue) | SNS ARN to send alarms/OK state changes to. Generally an OpsGenie queue. Defaults to the SRE OpsGenie queue. | `string` | `"arn:aws:sns:us-east-1:874873923888:OpsGenie"` | no |
| <a name="input_canary_steps"></a> [canary\_steps](#input\_canary\_steps) | A list of the named steps in your Canary function | `list(string)` | `null` | no |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | The environment that this canary will be deployed into (dev, staging, production) | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | The name of the service that this canary will be associated with | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | The name of the team that this canary will be associated with | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | The name of the handler function. Must end in .handler | `string` | n/a | yes |
| <a name="input_minutes"></a> [minutes](#input\_minutes) | The amount of minutes to wait between each canary runs. Valid values are 1-59 | `number` | `5` | no |
| <a name="input_name"></a> [name](#input\_name) | The additional identifier you'd like for the canary. This will be appended to capsule\_service-capsule-env | `string` | `null` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | Whether the endpoint being probed is internal or internet-facing. | `bool` | `false` | no |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | The runtime version to use for this canary. | `string` | n/a | yes |
| <a name="input_secret_recovery_window_in_days"></a> [secret\_recovery\_window\_in\_days](#input\_secret\_recovery\_window\_in\_days) | The recovery window in days for the secret that will be created for this canary. | `number` | `0` | no |
| <a name="input_secret_value"></a> [secret\_value](#input\_secret\_value) | The value for the secret that will be created for this canary. | `string` | `null` | no |
| <a name="input_success_percent_alert_eval_period"></a> [success\_percent\_alert\_eval\_period](#input\_success\_percent\_alert\_eval\_period) | The timeframe that success percent alert is evaluated over | `string` | `"10m"` | no |
| <a name="input_success_percent_alert_runbook_url"></a> [success\_percent\_alert\_runbook\_url](#input\_success\_percent\_alert\_runbook\_url) | The runbook url for success percent alert | `string` | `"https://add-a-runbook.com"` | no |
| <a name="input_success_percent_alert_severity"></a> [success\_percent\_alert\_severity](#input\_success\_percent\_alert\_severity) | The severity for success percent alert | `string` | `"info"` | no |
| <a name="input_success_percent_alert_threshold"></a> [success\_percent\_alert\_threshold](#input\_success\_percent\_alert\_threshold) | The threshold to trigger success percent alert | `string` | `"90"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarms"></a> [alarms](#output\_alarms) | An array of 0 or more alarms created |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the created canary |
| <a name="output_id"></a> [id](#output\_id) | The ID of the created canary |
| <a name="output_status"></a> [status](#output\_status) | The status of the created canary |
<!-- END_TF_DOCS -->
