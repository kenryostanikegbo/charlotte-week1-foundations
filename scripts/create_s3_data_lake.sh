#!/usr/bin/env bash
set -euo pipefail
STUDENT_ID="$1"
PROFILE="${2:-training}"
REGION="eu-north-1"
ACCOUNT_ID="985539802864"
BUCKET_NAME="charlotte-week1-${STUDENT_ID}-${ACCOUNT_ID}-${REGION}"
echo "Creating S3 bucket: ${BUCKET_NAME}"
aws s3api create-bucket --bucket "${BUCKET_NAME}" --region "${REGION}" --create-bucket-configuration LocationConstraint="${REGION}" --profile "${PROFILE}" 2>&1 || echo "Bucket exists, continuing..."
aws s3api put-public-access-block --bucket "${BUCKET_NAME}" --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true --profile "${PROFILE}"
echo "Applying S3 Block Public Access..."
cat > lifecycle.json <<'EOF'
{
  "Rules": [{
    "ID": "transition-to-glacier",
    "Filter": {"Prefix": "raw/"},
    "Status": "Enabled",
    "Transitions": [{"Days": 90, "StorageClass": "GLACIER"}],
    "Expiration": {"Days": 2555},
    "AbortIncompleteMultipartUpload": {"DaysAfterInitiation": 7}
  }]
}
EOF
echo "Applying lifecycle configuration..."
aws s3api put-bucket-lifecycle-configuration --bucket "${BUCKET_NAME}" --lifecycle-configuration file://lifecycle.json --profile "${PROFILE}"
echo "S3 data lake provisioned successfully."
echo "Bucket: s3://${BUCKET_NAME}"
echo "${BUCKET_NAME}" > scripts/.bucket-name