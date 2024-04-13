## Description

Provisions AWS Route53 DNS Record.

## Examples

Route53 CNAME Record

```hcl
module "route53_record_cname" {
  source = "github.com/CapsuleHealth/terraform-modules-sre//global/route53/record"

  name    = "www.example.com"
  type    = "CNAME"
  records = ["www.google.com"]
}
```

Route53 CNAME Record ignore_changes set

```hcl
module "route53_record_cname" {
  source = "github.com/CapsuleHealth/terraform-modules-sre//global/route53/record"

  name    = "www.example.com"
  type    = "CNAME"
  records = ["www.google.com"]
  ignore_record_value_changes = true
}
```

Private Route53 A Record

```hcl
module "route53_record_private_cname" {
  source = "github.com/CapsuleHealth/terraform-modules-sre//global/route53/record"

  name    = "www.internal.example.com"
  type    = "a"
  private = true
  records = ["1.2.3.4"]
}
```

Alias Route53 Record

```hcl
module my_custom_website_bucket {
  source = "github.com/CapsuleHealth/terraform-modules-sre//region/s3/website"

  bucket_name = "mycoolwebsite.com"

  website_index_document = "home.html"
  website_error_document = "404.html"
  
  capsule_team    = "my-team"
  capsule_service = "my-service"
  capsule_env     = "my-env"
}

module "route53_record_s3_alias" {
  source = "github.com/CapsuleHealth/terraform-modules-sre//global/route53/record"

  name           = "www.example.com"
  type           = "A"
  alias_name     = module.my_public_bucket.website_domain
  alias_zone     = module.my_public_bucket.zone_id
  alias_evaluate = false
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias_evaluate"></a> [alias\_evaluate](#input\_alias\_evaluate)    | Whether Route 53 should check the health of the resource record set | `bool` | n/a | no |
| <a name="input_alias_name"></a> [alias\_name](#input\_alias\_name)                | DNS domain name for an alias CloudFront distribution, S3 bucket, ELB, or another resource record set in this hosted zone. | `string` | n/a | no |
| <a name="input_alias_zone"></a> [alias\_zone](#input\_alias\_zone)                | Hosted zone ID for an alias CloudFront distribution, S3 bucket, ELB, or Route 53 hosted zone | `string` | n/a | no |
| <a name="input_name"></a> [name](#input\_name)                                    | The name of the record. | `string` | n/a | yes |
| <a name="input_private"></a> [private](#input\_private)                           | Whether this DNS record should be created in a [private hosted zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-private.html). | `bool` | `false` | no |
| <a name="input_records"></a> [records](#input\_records)                           | A string list of records. To specify a single record value longer than 255 characters such as a TXT record for DKIM, add `\"\"` inside the Terraform configuration string (e.g. `"first255characters\"\"morecharacters"`). | `list` | n/a | no |
| <a name="input_type"></a> [type](#input\_type)                                    | The record type. Valid values are `A`, `AAAA`, `CAA`, `CNAME`, `DS`, `MX`, `NAPTR`, `NS`, `PTR`, `SOA`, `SPF`, `SRV` and `TXT`. | `string` | n/a | yes |
| <a name="input_ttl"></a> [ttl](#input\_ttl)                                       | The TTL of the record | `number` | `300` | no |
| <a name="input_tld"></a> [tld](#input\_tld)                                       | The TLD of this record. Use this if you want to designate a specific TLD to override the automatic TLD parsing process. | `string` | n/a | no |
| <a name="input_ignore_record_value_changes"></a> [ignore_record_value_changes](#input\_ignore_record_value_changes)                                       | Whether to ignore future changes to the record Value | `bool` | `false` | no |

## Outputs

No Outputs.

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
| [aws_route53_record.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.ignore_changes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias_evaluate"></a> [alias\_evaluate](#input\_alias\_evaluate) | Evaluate target alias health. | `bool` | `true` | no |
| <a name="input_alias_name"></a> [alias\_name](#input\_alias\_name) | Destination alias name. This attribute conflicts with records. | `string` | `null` | no |
| <a name="input_alias_zone"></a> [alias\_zone](#input\_alias\_zone) | Destination alias zone. This attribute conflicts with records. | `string` | `null` | no |
| <a name="input_ignore_record_value_changes"></a> [ignore\_record\_value\_changes](#input\_ignore\_record\_value\_changes) | After the DNS value is set for the record, ignore future changes. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the DNS record. (Required) | `string` | n/a | yes |
| <a name="input_private"></a> [private](#input\_private) | Whether the record should be created in a private hosted zone. | `bool` | `false` | no |
| <a name="input_records"></a> [records](#input\_records) | List of destination record values. This attribute conflicts with alias. | `list(any)` | `null` | no |
| <a name="input_tld"></a> [tld](#input\_tld) | The top-level domain. | `string` | `null` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | The TTL for the record. Default = 300. | `number` | `300` | no |
| <a name="input_type"></a> [type](#input\_type) | The Type of record to create. Must be "A" or "CNAME". (Required. Default = A) | `string` | `"A"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->