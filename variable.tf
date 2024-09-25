variable "region" {
  description = "Value for AWS region"
  type        = string
}
variable "project_name" {
  description = "Value for project name"
  type        = string
}
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}
variable "environment" {
  description = "Value for tipe of environment"
  type        = string
}
variable "logging_bucket_name" {
  description = "Value for logging bucket name"
  type = string
}
variable "enable_access_logging" {
  description = "Enable access logging for the S3 bucket"
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "The S3 bucket for storing access logs"
  type        = string
  default     = null
}

variable "custom_bucket_policy" {
  description = "Custom policy for the S3 bucket"
  type        = string
  default     = null
}

variable "lifecycle_rules" {
  description = "Additional lifecycle rules"
  type = list(object({
    id      = string
    enabled = bool
    prefix  = string
    expiration = object({
      days = number
    })
  }))
  default = []
}
