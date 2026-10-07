#!/bin/bash
# S3 Data Lake Provisioning Script - Charlotte Week 1

BUCKET_NAME="charlotte-datalake-hauwakabara-$(date +%Y%m%d)"
REGION="us-east-1"

echo "Creating S3 data lake bucket: $BUCKET_NAME"

# Create bucket
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION

# Enable versioning
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# Apply lifecycle policy
aws s3api put-bucket-lifecycle-configuration --bucket $BUCKET_NAME --lifecycle-configuration file://config/lifecycle-policy.json

# Create folder structure
aws s3api put-object --bucket $BUCKET_NAME --key raw/
aws s3api put-object --bucket $BUCKET_NAME --key processed/
aws s3api put-object --bucket $BUCKET_NAME --key curated/

echo "S3 Data Lake setup complete: $BUCKET_NAME"