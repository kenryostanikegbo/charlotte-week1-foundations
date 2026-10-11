#!/usr/bin/env bash
set -euo pipefail
STUDENT_ID="${1:?Usage: $0 <student-id> [aws-profile]}"
PROFILE="${2:-training}"
REGION="$(aws configure get region --profile "$PROFILE")"
if [[ -z "$REGION" ]]; then
    echo "ERROR: No AWS Region is configured for profile '$PROFILE'."
    exit 1
fi
ACCOUNT_ID="$(aws sts get-caller-identity --profile "$PROFILE" --query Account --output text)"
echo "AWS Account: $ACCOUNT_ID"
echo "AWS Region: $REGION"
BUCKET_NAME="charlotte-week1-${STUDENT_ID}-${ACCOUNT_ID}-${REGION}"
echo "Bucket name: $BUCKET_NAME"
echo "Creating S3 bucket..."
if [[ "$REGION" == "us-east-1" ]]; then
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION" --profile "$PROFILE"
else
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION" --create-bucket-configuration LocationConstraint="$REGION" --profile "$PROFILE"
fi
aws s3api put-public-access-block --bucket "$BUCKET_NAME" --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true --profile "$PROFILE"
echo "$BUCKET_NAME" > .bucket-name
aws s3api put-bucket-lifecycle-configuration --bucket "$BUCKET_NAME" --lifecycle-configuration file://config/lifecycle-policy.json --profile "$PROFILE"
echo "Done! Bucket $BUCKET_NAME created and configured."
EOFcat > scripts/create_s3_data_lake.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
STUDENT_ID="${1:?Usage: $0 <student-id> [aws-profile]}"
PROFILE="${2:-training}"
REGION="$(aws configure get region --profile "$PROFILE")"
if [[ -z "$REGION" ]]; then
    echo "ERROR: No AWS Region is configured for profile '$PROFILE'."
    exit 1
fi
ACCOUNT_ID="$(aws sts get-caller-identity --profile "$PROFILE" --query Account --output text)"
echo "AWS Account: $ACCOUNT_ID"
echo "AWS Region: $REGION"
BUCKET_NAME="charlotte-week1-${STUDENT_ID}-${ACCOUNT_ID}-${REGION}"
echo "Bucket name: $BUCKET_NAME"
echo "Creating S3 bucket..."
if [[ "$REGION" == "us-east-1" ]]; then
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION" --profile "$PROFILE"
else
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION" --create-bucket-configuration LocationConstraint="$REGION" --profile "$PROFILE"
fi
aws s3api put-public-access-block --bucket "$BUCKET_NAME" --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true --profile "$PROFILE"
echo "$BUCKET_NAME" > .bucket-name
aws s3api put-bucket-lifecycle-configuration --bucket "$BUCKET_NAME" --lifecycle-configuration file://config/lifecycle-policy.json --profile "$PROFILE"
echo "Done! Bucket $BUCKET_NAME created and configured."
