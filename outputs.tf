output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.secure_bucket.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.secure_bucket.arn
}

output "logging_target_bucket" {
  description = "The target bucket for S3 bucket logging"
  value       = aws_s3_bucket_logging.logging.target_bucket
}