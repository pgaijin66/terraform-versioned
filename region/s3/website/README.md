## Usage

To use this module one needs to declare a module block where the source will be this git repo and folder. The purpose of this module is to create an s3 bucket that will be used to host a static website. The module will create an encrypted s3 bucket, with versioning turned on. The module accepts a few input variables, which are documented below. It's also possible to create a bucket policy using this module. This is also documented below.

The module requires the user to provide a bucket name, standard Capsule tags, and a website configuration block. The user can also create CORS rules using this module.

The module supports creating either a website that will serve files from the bucket, or a website that will perform redirects to another endpoint. This is controlled by setting the `website_redirect_all_requests_to` var to some value. Please note that this value is exclusive with the option to serve files from the bucket. That is, if you choose to redirect all requests, the values for the index and error document will be ignored by the module.

In its simplest form, the module can be used by just setting the bucket name and Capsule tags. This will create a bucket with the necessary settings for website hosting, and will default to serving `index.html` from the root directory. If you'd like to customize the location of the index or error files, or add routing rules, it's necessary to set the corresponding vars. Similarly, any CORS rules or bucket policies are not set by default, and will need to be set by the user.

## Examples

Basic website:

```hcl
module my_website_bucket {
  source = "github.com/capsulehealth/terraform-modules-sre/region/s3/website"

  bucket_name = "mycoolwebsite.com"

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

Website with some website values changed:

```hcl
module my_custom_website_bucket {
  source = "github.com/capsulehealth/terraform-modules-sre/region/s3/website"

  bucket_name = "mycoolwebsite.com"

  website_index_document = "home.html"
  website_error_document = "404.html"
  website_routing_rules  = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF

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

Website with a CORS rule:

```hcl
module my_CORS_website_bucket {
  source = "github.com/capsulehealth/terraform-modules-sre/region/s3/website"

  bucket_name = "mycoolwebsite.com"

  cors_rule = [
    {
      allowed_methods = ["GET"]
      allowed_origins = ["https://google.com"]
      allowed_headers = ["*"]
      expose_headers  = [""]
    }
  ]

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

For more examples, take a look at examples.tf in the tests/ directory.

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
| [aws_s3_bucket_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name to give to the bucket | `string` | n/a | yes |
| <a name="input_bucket_policy"></a> [bucket\_policy](#input\_bucket\_policy) | The policy to attach to the bucket | `string` | `null` | no |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | The environment that this bucket will be deployed into (dev, staging, production) | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | The name of the service that this bucket will be associated with | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | The name of the team that this bucket will be associated with | `string` | n/a | yes |
| <a name="input_cors_rule"></a> [cors\_rule](#input\_cors\_rule) | List of CORS rules. Should be a list of maps. allowed\_methods and allowed\_origins is required per rule | `any` | `[]` | no |
| <a name="input_replication_configuration_role"></a> [replication\_configuration\_role](#input\_replication\_configuration\_role) | An AWS Identity and Access Management (IAM) role that Amazon S3 can assume to replicate objects on your behalf | `string` | `null` | no |
| <a name="input_replication_configuration_rule"></a> [replication\_configuration\_rule](#input\_replication\_configuration\_rule) | A list of maps for replication\_configuration rules. | `any` | `[]` | no |
| <a name="input_vanta_contains_ephi"></a> [vanta\_contains\_ephi](#input\_vanta\_contains\_ephi) | Vanta specific tag to specify if the resource contains electronic protected health information (ePHI) | `bool` | `false` | no |
| <a name="input_vanta_description"></a> [vanta\_description](#input\_vanta\_description) | Vanta specific tag to specify the purpose of resource | `string` | `"S3 Service"` | no |
| <a name="input_vanta_nonprod"></a> [vanta\_nonprod](#input\_vanta\_nonprod) | Vanta specific tag to if resource is non-prod | `bool` | `false` | no |
| <a name="input_vanta_owner"></a> [vanta\_owner](#input\_vanta\_owner) | Vanta specific tag to identify resource owner | `string` | `"Global"` | no |
| <a name="input_vanta_user_data"></a> [vanta\_user\_data](#input\_vanta\_user\_data) | Vanta specific tag to specify if the resource will contain user data | `bool` | `false` | no |
| <a name="input_vanta_user_data_stored"></a> [vanta\_user\_data\_stored](#input\_vanta\_user\_data\_stored) | Vanta specific tag to specify the type of data the resource transacts/stores | `string` | `"Stored Account Information"` | no |
| <a name="input_website_error_document"></a> [website\_error\_document](#input\_website\_error\_document) | The file S3 should return when a 4xx error is encountered | `string` | `null` | no |
| <a name="input_website_index_document"></a> [website\_index\_document](#input\_website\_index\_document) | The file S3 should return when calls are made to the root domain, or subfolders | `string` | `"index.html"` | no |
| <a name="input_website_redirect_all_requests_to"></a> [website\_redirect\_all\_requests\_to](#input\_website\_redirect\_all\_requests\_to) | A host to redirect all requests to. If set, the website\_index\_document variable will not be used | `string` | `null` | no |
| <a name="input_website_routing_rules"></a> [website\_routing\_rules](#input\_website\_routing\_rules) | An array of routing rules for redirect behaviors | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the created bucket |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | The bucket domain name of the created bucket |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | The bucket region-specific domain name of the created bucket |
| <a name="output_id"></a> [id](#output\_id) | The name of the created bucket |
| <a name="output_website_domain"></a> [website\_domain](#output\_website\_domain) | The domain of the created bucket |
| <a name="output_website_endpoint"></a> [website\_endpoint](#output\_website\_endpoint) | The website endpoint for the created bucket |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The hosted zone ID for the bucket's region |
<!-- END_TF_DOCS -->