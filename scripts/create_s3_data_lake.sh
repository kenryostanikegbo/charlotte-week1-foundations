#!/usr/bin/env bash
set -euo pipefail
#!/usr/bin/env bash
set -euo pipefail

# 35. Define the AWS CLI profile
PROFILE="${1:-training}"

# 36. Read and validate the Region
REGION="$(aws configure get region --profile "$PROFILE")"

if [[ -z "$REGION" ]]; then
  echo "ERROR: No AWS Region is configured for profile '$PROFILE'."
  exit 1
fi

# 37. Verify the AWS account inside the script
ACCOUNT_ID="$(aws sts get-caller-identity --profile "$PROFILE" --query Account --output text)"

echo "AWS Account: $ACCOUNT_ID"
echo "AWS Region: $REGION"
echo "AWS Profile: $PROFILE"

# 38. Build a unique training bucket name
BUCKET_NAME="sensor-data-lake-${ACCOUNT_ID}-${REGION}"
echo "Bucket name: $BUCKET_NAME"

# 39. Create the S3 bucket
echo "Creating S3 bucket..."
if [[ "$REGION" == "us-east-1" ]]; then
  aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION" --profile "$PROFILE"
else
  aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION" --profile "$PROFILE" --create-bucket-configuration LocationConstraint="$REGION"
fi# 40. Enforce S3 Block Public Access
echo "Applying S3 Block Public Access..."
aws s3api put-public-access-block --bucket "$BUCKET_NAME" --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true --profile "$PROFILE"

# 41. Save the generated bucket name locally
echo "$BUCKET_NAME" > bucket-name
echo "Saved bucket name to ./bucket-name"

# 42. Create the lifecycle configuration file
echo "Creating lifecycle configuration..."
cat > config/lifecycle.json << 'EOF'
{
  "Rules": [
    {
      "ID": "sensor-data-retention",
      "Status": "Enabled",
      "Filter": {
        "Prefix": "raw/"
      },
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "STANDARD_IA"
        },
        {
          "Days": 180,
          "StorageClass": "GLACIER"
        }
      ],
            "Expiration": {
        "Days": 2555
      },
      "AbortIncompleteMultipartUpload": {
        "DaysAfterInitiation": 7
      }
    }
  ]
}
EOF
echo "Applying lifecycle configuration..."
aws s3api put-bucket-lifecycle-configuration --bucket "$BUCKET_NAME" --lifecycle-configuration file://config/lifecycle.json --profile "$PROFILE"

echo "Verifying bucket..."
aws s3api head-bucket --bucket "$BUCKET_NAME" --profile "$PROFILE"

echo "Verifying lifecycle configuration..."
aws s3api get-bucket-lifecycle-configuration --bucket "$BUCKET_NAME" --profile "$PROFILE"

echo "S3 Data Lake setup complete for bucket: $BUCKET_NAME"