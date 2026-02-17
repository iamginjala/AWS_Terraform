# Simple Image Processor - Summary

## Why Lambda?
Lambda was chosen because it can be triggered automatically when an image is uploaded to S3 - no servers to manage, no infrastructure running 24/7. It only runs when needed.

## Architecture Flow

### 1. Two S3 Buckets (Source + Destination)
- **Source bucket**: Stores the uploaded images
- **Destination bucket**: Stores the processed images (5 variants)
- **Why two buckets?** If we store processed images back in the same bucket, the S3 event notification fires again, triggering Lambda again, creating an **infinite loop** with unexpected costs

### 2. S3 Public Access Block
- Block all public access on both buckets
- Security best practice - these are internal processing buckets, not public-facing

### 3. IAM Role + Policy
- **Question to self: Why do we need a role?**
  - A role is an identity that a service (like Lambda) can assume
  - Without it, Lambda has zero permissions - it can't read from S3 or write to S3
- **IAM Policy**: Grants `s3:GetObject` on source bucket and `s3:PutObject` on destination bucket (least privilege)
- **Managed Policy**: `AWSLambdaBasicExecutionRole` attached for CloudWatch Logs access - without this, we can't see Lambda logs for debugging

### 4. Lambda Layer
- **Question to self: Why do we need a layer?**
  - Pillow (image processing library) has compiled C extensions
  - These are platform-specific - a Windows build won't work on Lambda (Amazon Linux)
  - The layer packages the Linux-compatible version of Pillow separately
  - Must use `--platform manylinux2014_x86_64` and `--python-version 3.12` when downloading

### 5. Lambda Function
- Processes uploaded images into 5 variants:
  - Compressed JPEG (quality 85)
  - Low quality JPEG (quality 60)
  - WebP format
  - PNG format
  - Thumbnail (300x300)
- Environment variables pass the destination bucket name and log level

### 6. CloudWatch Log Group
- Pre-created with 7-day retention to avoid unlimited log accumulation and cost

### 7. Lambda Permission
- Tells Lambda: "S3 is allowed to invoke you"
- Scoped to the specific source bucket ARN for security
- Without this, S3 events fire but Lambda rejects them

### 8. S3 Bucket Notification
- The trigger that connects everything
- Fires on `s3:ObjectCreated:*` events
- `depends_on` Lambda Permission to ensure correct creation order

## Key Lessons Learned
- Environment variable names must match between Terraform and Python code
- Lambda Layer requires correct Python version AND platform when packaging
- `pip install --no-user` may be needed if pip config has `--user` set by default
- `force_destroy = true` on S3 buckets allows Terraform to delete non-empty buckets (dev only)
- `source_code_hash` on Lambda and Layer ensures Terraform detects code changes

## Terraform Files Structure
```
Image-processor/
  provider.tf      - AWS, archive, random providers
  backend.tf       - S3 remote state with locking
  variables.tf     - environment, project_name, tags
  data.tf          - archive_file for lambda.zip and layer.zip
  main.tf          - All resources
  outputs.tf       - Bucket names, Lambda function name
  lambda/
    handler.py     - Python image processing code
  layer/
    python/        - Pillow library (Linux build, .gitignored)
```
