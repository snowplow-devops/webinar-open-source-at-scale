aws_region = "ap-southeast-2"

# Will be prefixed to all resource names
# Use this to easily identify the resources created and provide entropy for subsequent environments
prefix = "sp-osatscale"

# --- Default VPC
# Update to the VPC you would like to deploy into
# Find your default: https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html#view-default-vpc
vpc_id            = "vpc-00000000"
public_subnet_ids = ["subnet-00000000", "subnet-00000001"]

# --- SSH
# Update this to your IP Address
ssh_ip_allowlist = ["999.999.999.999/32"]
# Generate a new SSH key locally with `ssh-keygen`
# ssh-keygen -t rsa -b 4096 
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQA0jSi9//bRsHW4M6czodTs6smCXsxZ0gijzth0aBmycE= snowplow@Snowplows-MacBook-Pro.local"

# --- Snowflake loader setup (https://github.com/snowplow-devops/terraform-aws-snowflake-loader-ec2#usage)
snowflake_loader_user     = "<USER>"
snowflake_loader_password = "<PASSWORD>" # Keep this a secret!
snowflake_warehouse       = "<WAREHOUSE>"
snowflake_database        = "<DATABASE>"
snowflake_schema          = "<SCHEMA>"
snowflake_region          = "<REGION>"
snowflake_account         = "<ACCOUNT>"

# --- Kinesis scaling options
kinesis_stream_mode_details = "PROVISIONED" # Change to: "ON_DEMAND" to have it auto-scale

# --- EC2 scaling options
ec2_enable_auto_scaling = false # Change to: "true" to have EC2 groups auto-scale based on CPU

# EC2 settings for Collector
ec2_collector_min_size      = 1
ec2_collector_max_size      = 1
ec2_collector_instance_type = "t3a.micro"

# EC2 settings for Enrich
ec2_enrich_min_size      = 1
ec2_enrich_max_size      = 1
ec2_enrich_instance_type = "t3a.small"
# DynamoDB setting which controls how fast the Enrich KCL can checkpoint records
dyndb_enrich_kcl_read_min_capacity  = 1
dyndb_enrich_kcl_read_max_capacity  = 1
dyndb_enrich_kcl_write_min_capacity = 1
dyndb_enrich_kcl_write_max_capacity = 1

# EC2 settings for Transformer (Note: there is only vertical scaling available safely here so no auto-scaling)
ec2_transformer_instance_type = "t3a.small"
# DynamoDB setting which controls how fast the Enrich KCL can checkpoint records
dyndb_transformer_kcl_read_min_capacity  = 1
dyndb_transformer_kcl_read_max_capacity  = 1
dyndb_transformer_kcl_write_min_capacity = 1
dyndb_transformer_kcl_write_max_capacity = 1

# --- AWS IAM (advanced setting)
iam_permissions_boundary = "" # e.g. "arn:aws:iam::0000000000:policy/MyAccountBoundary"

# See for more information: https://registry.terraform.io/modules/snowplow-devops/collector-kinesis-ec2/aws/latest#telemetry
# Telemetry principles: https://docs.snowplowanalytics.com/docs/open-source-quick-start/what-is-the-quick-start-for-open-source/telemetry-principles/
user_provided_id  = ""
telemetry_enabled = true
