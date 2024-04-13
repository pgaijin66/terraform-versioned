## Usage

To use this module one needs to declare a module block where the source will be this git repo and folder. The module will create an encrypted s3 bucket, with versioning turned on. The module accepts a few input variables, which are documented below. It's also possible to create a bucket policy using this module. This is also documented below.

The module requires the user to provide a bucket name and standard Capsule tags.

The module supports a private and public use case. This is controlled by setting the `access` var to be either `private` or `public`. Please note that by default the bucket will be private. Only change it to be public if you are sure that files need to be accessible to the outside world. You should be very careful with setting a bucket public, as it may expose sensitive data.

## Examples

Private bucket:

```hcl
module my_private_bucket {
  source = "github.com/capsulehealth/terraform-modules-sre/region/s3/standard"

  bucket_name = "capsule-private-bucket"
  capsule_team            = "my-team"
  capsule_service         = "my-service"
  capsule_env             = "my-env"
  vanta_owner             = "my-team"
  vanta_nonprod           = "true"
  vanta_description       = "This bucket hosts static JS"
  vanta_user_data         = "false"
  vanta_user_data_stored  = "None"
  vanta_contains_ephi     = "false"
}
```

Public bucket:

```hcl
module my_public_bucket {
  source = "github.com/capsulehealth/terraform-modules-sre/region/s3/standard"

  bucket_name = "capsule-public-bucket"
  access      = "public"

  capsule_team            = "my-team"
  capsule_service         = "my-service"
  capsule_env             = "my-env"
  vanta_owner             = "my-team"
  vanta_nonprod           = "true"
  vanta_description       = "This bucket hosts static JS"
  vanta_user_data         = "false"
  vanta_user_data_stored  = "None"
  vanta_contains_ephi     = "false"
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
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access"></a> [access](#input\_access) | The access level for the bucket | `string` | `"private"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name to give to the bucket | `string` | n/a | yes |
| <a name="input_bucket_policy"></a> [bucket\_policy](#input\_bucket\_policy) | The policy to attach to the bucket | `string` | `null` | no |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | The environment that this bucket will be deployed into (dev, staging, production) | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | The name of the service that this bucket will be associated with | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | The name of the team that this bucket will be associated with | `string` | n/a | yes |
| <a name="input_cors_rule"></a> [cors\_rule](#input\_cors\_rule) | List of CORS rules. Should be a list of maps. allowed\_methods and allowed\_origins is required per rule | `list(any)` | `[]` | no |
| <a name="input_grants"></a> [grants](#input\_grants) | The ACL grants for the bucket | `list(any)` | `[]` | no |
| <a name="input_lifecycle_rule"></a> [lifecycle\_rule](#input\_lifecycle\_rule) | Collection of lifecycle rules for objects in s3 bucket | `list(any)` | `[]` | no |
| <a name="input_vanta_contains_ephi"></a> [vanta\_contains\_ephi](#input\_vanta\_contains\_ephi) | Vanta specific tag to specify if the resource contains electronic protected health information (ePHI) | `bool` | `false` | no |
| <a name="input_vanta_description"></a> [vanta\_description](#input\_vanta\_description) | Vanta specific tag to specify the purpose of resource | `string` | `"S3 Service"` | no |
| <a name="input_vanta_nonprod"></a> [vanta\_nonprod](#input\_vanta\_nonprod) | Vanta specific tag to if resource is non-prod | `bool` | `false` | no |
| <a name="input_vanta_owner"></a> [vanta\_owner](#input\_vanta\_owner) | Vanta specific tag to identify resource owner | `string` | `"Global"` | no |
| <a name="input_vanta_user_data"></a> [vanta\_user\_data](#input\_vanta\_user\_data) | Vanta specific tag to specify if the resource will contain user data | `bool` | `false` | no |
| <a name="input_vanta_user_data_stored"></a> [vanta\_user\_data\_stored](#input\_vanta\_user\_data\_stored) | Vanta specific tag to specify the type of data the resource transacts/stores | `string` | `"Stored Account Information"` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Specifies if versioning should be enabled or not | `bool` | `"true"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the created bucket |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | The bucket domain name of the created bucket |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | The bucket region-specific domain name of the created bucket |
| <a name="output_id"></a> [id](#output\_id) | The name of the created bucket |
<!-- END_TF_DOCS -->
