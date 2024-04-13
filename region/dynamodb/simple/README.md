## Usage

To use this module one needs to declare a module block where the source will 
be this git repo and folder. The module will create a DynamoDB table with 
`PAY_PER_REQUEST` billing mode. Table name is interpolated `"${var.capsule_service}-[${var.name}-]-${var.capsule_env}"`.
The module accepts a few input variables, which are documented below.

The module requires the user to provide standard Capsule tags and the table 
hash key.

## Examples

Basic table:

```hcl
module "example_dynamodb_table" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/dynamodb/simple"

  hash_key        = "my_key"
  capsule_env     = "staging"
  capsule_team    = "my-team"
  capsule_service = "my-service"
}
```

Table with explicit read and write capacity set:

```hcl
module "example_dynamodb_table_provisioned" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/dynamodb/simple"

  hash_key        = "my_key"
  billing_mode    = "PROVISIONED"
  read_capacity   = 20
  write_capacity  = 10
  capsule_env     = "staging"
  capsule_team    = "my-team"
  capsule_service = "my-service"
}
```

Table with attributes and global secondary indices:

```hcl
module "example_dynamodb_table_provisioned" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/dynamodb/simple"

  hash_key        = "my_key"
  capsule_env     = "staging"
  capsule_team    = "my-team"
  capsule_service = "my-service"

  attributes = [
    {
      name = "attr1"
      type = "S"
    },
    {
      name = "attr2"
      type = "S"
    },
    {
      name = "attr3"
      type = "S"
    }
  ]

  global_secondary_indices = [
    {
      name            = "gbi1"
      hash_key        = "attr1"
      range_key       = "attr2"
      projection_type = "ALL"
    },
    {
      name            = "gbi2"
      hash_key        = "attr2"
      range_key       = "attr3"
      projection_type = "ALL"
    }
  ]
}
```

Table in Prod with Vanta Tags


```hcl
module "example_dynamodb_table" {
  source = "github.com/capsulehealth/terraform-modules-sre/region/dynamodb/simple"

  hash_key        = "my_key"
  capsule_env     = "prod"
  capsule_team    = "my-team"
  capsule_service = "my-service"
  
  vanta_owner            = "my-team"
  vanta_description      = "my-description"
  vanta_contains_ephi    = false
  vanta_nonprod          = false
  vanta_user_data        = false
  vanta_user_data_stored = "Must be unicode characters from the set of letters, digits, whitespace"
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
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional DynamoDB attributes in the form of a list of mapped values | <pre>list(object({<br>    name = string<br>    type = string<br>  }))</pre> | `[]` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | DynamoDB Billing mode. Can be PROVISIONED or PAY\_PER\_REQUEST. Defaults to 'PAY\_PER\_REQUEST'. | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_capsule_env"></a> [capsule\_env](#input\_capsule\_env) | The Capsule environment that this resource will be deployed into (dev, staging, production) | `string` | n/a | yes |
| <a name="input_capsule_service"></a> [capsule\_service](#input\_capsule\_service) | The name of the Capsule service that this resource will be associated with | `string` | n/a | yes |
| <a name="input_capsule_team"></a> [capsule\_team](#input\_capsule\_team) | The name of the Capsule team that this resource will be associated with | `string` | n/a | yes |
| <a name="input_enable_encryption"></a> [enable\_encryption](#input\_enable\_encryption) | Enable DynamoDB server-side encryption | `bool` | `true` | no |
| <a name="input_encryption_kms_key_arn"></a> [encryption\_kms\_key\_arn](#input\_encryption\_kms\_key\_arn) | The ARN of the KMS encryption key. Defaults to 'alias/aws/dynamodb'. | `string` | `null` | no |
| <a name="input_global_secondary_indices"></a> [global\_secondary\_indices](#input\_global\_secondary\_indices) | Additional DynamoDB attributes in the form of a list of mapped values | <pre>list(object({<br>    name               = string<br>    hash_key           = string<br>    range_key          = optional(string)<br>    write_capacity     = optional(number)<br>    read_capacity      = optional(number)<br>    projection_type    = string<br>    non_key_attributes = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | This is also known as the partition key and is required by dynamodb as the primary key | `string` | n/a | yes |
| <a name="input_hash_key_type"></a> [hash\_key\_type](#input\_hash\_key\_type) | Specify the hash key type. Options are (S)tring, (N)umber or (B)inary data. Defaults to 'S'. | `string` | `"S"` | no |
| <a name="input_legacy_name"></a> [legacy\_name](#input\_legacy\_name) | Will be deprecated. Do not use this value, for pre-existing legacy tables only. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to give the dynamodb table that you want to create | `string` | `null` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | DynamoDB table Range Key | `string` | `null` | no |
| <a name="input_range_key_type"></a> [range\_key\_type](#input\_range\_key\_type) | Specify the range key type. Options are (S)tring, (N)umber or (B)inary data. Defaults to 'S'. | `string` | `"S"` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | DynamoDB read capacity | `number` | `5` | no |
| <a name="input_ttl_attribute"></a> [ttl\_attribute](#input\_ttl\_attribute) | DynamoDB table TTL attribute | `string` | `"Expires"` | no |
| <a name="input_ttl_enabled"></a> [ttl\_enabled](#input\_ttl\_enabled) | Whether to enable the ttl attribute for items in the table. | `bool` | `false` | no |
| <a name="input_vanta_contains_ephi"></a> [vanta\_contains\_ephi](#input\_vanta\_contains\_ephi) | Vanta specific tag to specify if the resource contains electronic protected health information (ePHI) | `bool` | `false` | no |
| <a name="input_vanta_description"></a> [vanta\_description](#input\_vanta\_description) | Vanta specific tag to specify the purpose of resource | `string` | `"DynamoDB Service"` | no |
| <a name="input_vanta_nonprod"></a> [vanta\_nonprod](#input\_vanta\_nonprod) | Vanta specific tag to if resource is non-prod | `bool` | `false` | no |
| <a name="input_vanta_owner"></a> [vanta\_owner](#input\_vanta\_owner) | Vanta specific tag to identify resource owner | `string` | `"Global"` | no |
| <a name="input_vanta_user_data"></a> [vanta\_user\_data](#input\_vanta\_user\_data) | Vanta specific tag to specify if the resource will contain user data | `bool` | `false` | no |
| <a name="input_vanta_user_data_stored"></a> [vanta\_user\_data\_stored](#input\_vanta\_user\_data\_stored) | Vanta specific tag to specify the type of data the resource transacts/stores | `string` | `"Stored Account Information"` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | DynamoDB write capacity | `number` | `5` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | n/a |
| <a name="output_table_id"></a> [table\_id](#output\_table\_id) | n/a |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | n/a |
<!-- END_TF_DOCS -->
