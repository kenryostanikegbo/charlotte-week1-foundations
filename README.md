# Week 1 - Git, AWS CLI and S3 Data Lake

## Prerequisites
- Git and AWS CLI version 2 are prerequisites.

## Provisioning
- The default CLI profile is `training`.
- The script is run with `./scripts/create_s3_data_lake.sh`.

## Data Ingestion and Lifecycle
- Verified upload: `aws s3 ls "s3://$BUCKET_NAME/raw/pressure/2026/10/06/" --profile training`
- The lifecycle rule is configured for object age. A newly uploaded object is not yet 30 or 180 days old, so no transition happens immediately.
- raw/ objects transition to Standard-IA after 30 days and Glacier Flexible Retrieval after 180 days.

## Security and Retention
- S3 Block Public Access is enabled.
- Credentials and private SSH keys must never be committed.
- The training expiration is approximately seven years.

## Verification
- `aws s3api get-bucket-lifecycle-configuration --bucket $BUCKET_NAME --profile training`
