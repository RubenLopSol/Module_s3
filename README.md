# Terraform module s3 bucket

Terraform module that creates a secure S3 bucket with the specified configurations, including options for access logging, custom policies, and additional lifecycle rules.

## Requirements

**1**. Install Terraform.

**2**. Ensure you have access to AWS S3 services (and that your AWS profile is configured locally or on your server).

## Module Usage

### Step 1:

- To create an S3 bucket, use the code below:

Example:

```terraform
module "s3-bucket" {
  source                = "git::https://github.com/RubenLopSol/Module_s3.git"
  bucket_name           = var.bucket_name
  enable_access_logging = true
  logging_bucket        = var.logging-bucket-name
  environment           = var.environment

  lifecycle_rules = [
    {
      id      = "delete-old-logs",
      enabled = true,
      prefix  = "logs/",
      expiration = {
        days = 365
      }
    }
  ]
}
```
### Step 2: Set the Variables

- In your `variables.tf` file, set the variables that the module requires.

### Step 3: Initialize & Apply

- Run `terraform init` to initialize the Terraform environment and download the module dependencies.
```terraform
terraform init
```
- Apply the configuration to create your S3 bucket by running.
```terraform
terraform apply
```
### Step 4: Verify Resources

Once the `terraform apply` completes, your S3 bucket will be created with the following:

- Logging enabled (if configured).
- Lifecycle rules applied for the logs folder.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.secure_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_policy.secure_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.sse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | Value for AWS region | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Value for tipe of environment | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Value for project name | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket | `string` | n/a | yes |
| <a name="input_logging_bucket"></a> [logging\_bucket\_name](#input\_logging\_bucket\_name) | The S3 bucket for storing access logs | `string` | `null` | no |
| <a name="input_custom_bucket_policy"></a> [custom\_bucket\_policy](#input\_custom\_bucket\_policy) | Custom policy for the S3 bucket | `string` | `null` | no |
| <a name="input_enable_access_logging"></a> [enable\_access\_logging](#input\_enable\_access\_logging) | Enable access logging for the S3 bucket | `bool` | `false` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | Additional lifecycle rules | <pre>list(object({<br>    id      = string<br>    enabled = bool<br>    prefix  = string<br>    expiration = object({<br>      days = number<br>    })<br>  }))</pre> | `[]` | no |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the S3 bucket |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Name of bucket S3 |
| <a name="output_bucket_name"></a> [logging\_bucket\_name](#output\_logging\target\_bucket) | The target bucket for S3 bucket logging |
