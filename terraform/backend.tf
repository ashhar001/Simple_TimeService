# Terraform backend configuration for remote state
# This configuration uses a shared S3 bucket for state storage and DynamoDB table for state locking

terraform {
  backend "s3" {
    # Remote state configuration
    bucket = "terraform-state-522814697098-us-east-2"
    key    = "simple-time-service/terraform.tfstate"
    region = "us-east-2"

    # State locking configuration (using DynamoDB)
    dynamodb_table = "terraform-locks-522814697098"

    # Enable server-side encryption
    encrypt = true
  }
}

# --- Remote Backend Information ---
# 
# This project uses a centralized remote backend with the following components:
#
# S3 Bucket: terraform-state-522814697098-us-east-2
# - Versioning is enabled to maintain state history
# - Server-side encryption is enabled for security
# - All public access is blocked
#
# DynamoDB Table: terraform-locks-522814697098
# - Provides state locking to prevent concurrent operations
# - Uses the "LockID" partition key as required by Terraform
# - Point-in-time recovery is enabled
#
# Benefits of this configuration:
# - Team collaboration: Multiple team members can work safely on the same configuration
# - State history: Previous state versions are preserved in S3 versioning
# - Disaster recovery: Remote state is backed up and secure
# - State locking: Prevents concurrent modifications that could corrupt state
#
# Note: When running terraform commands, you'll notice messages about acquiring
# and releasing state locks. This indicates the locking mechanism is working correctly.
