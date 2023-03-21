# Webinar: Open source at Scale

This repo contains example Terraform code for deploying a base pipeline in AWS that loads data into Snowflake as well as detailing the core settings that you need to tweak to get the pipeline to scale up.

## Usage

Running this module will require you to setup a few inputs first - take your time and walk through these carefully to ensure everything gets setup properly.  These instructions are quite closely modelled on our existing `quickstart-examples` and you can find more detail / FAQs [here](https://docs.snowplow.io/docs/getting-started-on-snowplow-open-source/quick-start-aws/).

Steps:

1. You will need to configure a Snowflake destination - you can follow the instructions noted [here](https://github.com/snowplow-devops/terraform-aws-snowflake-loader-ec2#usage) which will guide you through how to configure your Snowflake instance
2. Make a copy of the `terraform.example.tfvars` as `terraform.tfvars` and update the `snowflake_*` with your personal Snowflake settings
3. Update all other top level settings with your own `vpc_id` / `subnet_ids`, `prefix`, `ssh_ip_allowlist` and `ssh_public_key`:
  * The VPC settings you can use the default network [made available in your AWS account](https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html#view-default-vpc)
  * Prefix should be unique to "you" so as not to run into global conflicts
  * You should generate a new SSH key with something like `ssh-keygen -t rsa -b 4096` - you will need to update `ssh_public_key` with the `.pub` part of the generated key

## Setting up for scale

There are several exposed settings here that you will need to tune to get ready for scale - notably you will need to:

1. Ensure EC2 auto-scaling is setup and that "max" instance counts are increased to allow for head-room
2. Ensure Kinesis is auto-scaling to allow it to be more reactive to event volume changes
3. Ensure SnowflakeDB warehouse is large enough to support loading the pipeline fast enough
4. Ensure DynamoDB KCL tables can scale high enough to support the aggressive checkpointing needed
5. Ensure that Transformer is correctly vertically scaled to support load (Note: does not provide auto-scaling with Kinesis)

These settings and guidance are provided in the webinar (watch the recording!) but ultimately you need to tune the above settings until the pipeline absorbs all your traffic peaks without latency building up.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.75.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.75.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bad_1_stream"></a> [bad\_1\_stream](#module\_bad\_1\_stream) | snowplow-devops/kinesis-stream/aws | 0.3.0 |
| <a name="module_collector_kinesis"></a> [collector\_kinesis](#module\_collector\_kinesis) | snowplow-devops/collector-kinesis-ec2/aws | 0.5.1 |
| <a name="module_collector_lb"></a> [collector\_lb](#module\_collector\_lb) | snowplow-devops/alb/aws | 0.2.0 |
| <a name="module_enrich_kinesis"></a> [enrich\_kinesis](#module\_enrich\_kinesis) | snowplow-devops/enrich-kinesis-ec2/aws | 0.5.1 |
| <a name="module_enriched_stream"></a> [enriched\_stream](#module\_enriched\_stream) | snowplow-devops/kinesis-stream/aws | 0.3.0 |
| <a name="module_raw_stream"></a> [raw\_stream](#module\_raw\_stream) | snowplow-devops/kinesis-stream/aws | 0.3.0 |
| <a name="module_s3_pipeline_bucket"></a> [s3\_pipeline\_bucket](#module\_s3\_pipeline\_bucket) | snowplow-devops/s3-bucket/aws | 0.2.0 |
| <a name="module_sf_loader"></a> [sf\_loader](#module\_sf\_loader) | snowplow-devops/snowflake-loader-ec2/aws | 0.2.1 |
| <a name="module_transformer_wrj"></a> [transformer\_wrj](#module\_transformer\_wrj) | snowplow-devops/transformer-kinesis-ec2/aws | 0.3.2 |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_sqs_queue.sf_message_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dyndb_enrich_kcl_read_max_capacity"></a> [dyndb\_enrich\_kcl\_read\_max\_capacity](#input\_dyndb\_enrich\_kcl\_read\_max\_capacity) | Max read units for Enrich KCL Table | `number` | n/a | yes |
| <a name="input_dyndb_enrich_kcl_read_min_capacity"></a> [dyndb\_enrich\_kcl\_read\_min\_capacity](#input\_dyndb\_enrich\_kcl\_read\_min\_capacity) | Min read units for Enrich KCL Table | `number` | n/a | yes |
| <a name="input_dyndb_enrich_kcl_write_max_capacity"></a> [dyndb\_enrich\_kcl\_write\_max\_capacity](#input\_dyndb\_enrich\_kcl\_write\_max\_capacity) | Max write units for Enrich KCL Table | `number` | n/a | yes |
| <a name="input_dyndb_enrich_kcl_write_min_capacity"></a> [dyndb\_enrich\_kcl\_write\_min\_capacity](#input\_dyndb\_enrich\_kcl\_write\_min\_capacity) | Min write units for Enrich KCL Table | `number` | n/a | yes |
| <a name="input_dyndb_transformer_kcl_read_max_capacity"></a> [dyndb\_transformer\_kcl\_read\_max\_capacity](#input\_dyndb\_transformer\_kcl\_read\_max\_capacity) | Max read units for Transformer KCL Table | `number` | n/a | yes |
| <a name="input_dyndb_transformer_kcl_read_min_capacity"></a> [dyndb\_transformer\_kcl\_read\_min\_capacity](#input\_dyndb\_transformer\_kcl\_read\_min\_capacity) | Min read units for Transformer KCL Table | `number` | n/a | yes |
| <a name="input_dyndb_transformer_kcl_write_max_capacity"></a> [dyndb\_transformer\_kcl\_write\_max\_capacity](#input\_dyndb\_transformer\_kcl\_write\_max\_capacity) | Max write units for Transformer KCL Table | `number` | n/a | yes |
| <a name="input_dyndb_transformer_kcl_write_min_capacity"></a> [dyndb\_transformer\_kcl\_write\_min\_capacity](#input\_dyndb\_transformer\_kcl\_write\_min\_capacity) | Min write units for Transformer KCL Table | `number` | n/a | yes |
| <a name="input_ec2_collector_instance_type"></a> [ec2\_collector\_instance\_type](#input\_ec2\_collector\_instance\_type) | Instance type for Collector | `string` | n/a | yes |
| <a name="input_ec2_collector_max_size"></a> [ec2\_collector\_max\_size](#input\_ec2\_collector\_max\_size) | Max number of nodes for Collector | `number` | n/a | yes |
| <a name="input_ec2_collector_min_size"></a> [ec2\_collector\_min\_size](#input\_ec2\_collector\_min\_size) | Min number of nodes for Collector | `number` | n/a | yes |
| <a name="input_ec2_enable_auto_scaling"></a> [ec2\_enable\_auto\_scaling](#input\_ec2\_enable\_auto\_scaling) | Whether to enable EC2 auto-scaling for Collector & Enrich | `bool` | n/a | yes |
| <a name="input_ec2_enrich_instance_type"></a> [ec2\_enrich\_instance\_type](#input\_ec2\_enrich\_instance\_type) | Instance type for Enrich | `string` | n/a | yes |
| <a name="input_ec2_enrich_max_size"></a> [ec2\_enrich\_max\_size](#input\_ec2\_enrich\_max\_size) | Max number of nodes for Enrich | `number` | n/a | yes |
| <a name="input_ec2_enrich_min_size"></a> [ec2\_enrich\_min\_size](#input\_ec2\_enrich\_min\_size) | Min number of nodes for Enrich | `number` | n/a | yes |
| <a name="input_ec2_transformer_instance_type"></a> [ec2\_transformer\_instance\_type](#input\_ec2\_transformer\_instance\_type) | Instance type for Transformer | `string` | n/a | yes |
| <a name="input_kinesis_stream_mode_details"></a> [kinesis\_stream\_mode\_details](#input\_kinesis\_stream\_mode\_details) | The mode in which Kinesis Streams are setup | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Will be prefixed to all resource names. Use to easily identify the resources created | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | The list of public subnets to deploy the components across | `list(string)` | n/a | yes |
| <a name="input_snowflake_account"></a> [snowflake\_account](#input\_snowflake\_account) | Snowflake account to use | `string` | n/a | yes |
| <a name="input_snowflake_database"></a> [snowflake\_database](#input\_snowflake\_database) | Snowflake database name | `string` | n/a | yes |
| <a name="input_snowflake_loader_password"></a> [snowflake\_loader\_password](#input\_snowflake\_loader\_password) | The password to use for the loader user | `string` | n/a | yes |
| <a name="input_snowflake_loader_user"></a> [snowflake\_loader\_user](#input\_snowflake\_loader\_user) | The Snowflake user used by Snowflake Loader | `string` | n/a | yes |
| <a name="input_snowflake_region"></a> [snowflake\_region](#input\_snowflake\_region) | Region of Snowflake account | `string` | n/a | yes |
| <a name="input_snowflake_schema"></a> [snowflake\_schema](#input\_snowflake\_schema) | Snowflake schema name | `string` | n/a | yes |
| <a name="input_snowflake_warehouse"></a> [snowflake\_warehouse](#input\_snowflake\_warehouse) | Snowflake warehouse name | `string` | n/a | yes |
| <a name="input_ssh_ip_allowlist"></a> [ssh\_ip\_allowlist](#input\_ssh\_ip\_allowlist) | The list of CIDR ranges to allow SSH traffic from | `list(any)` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The SSH public key to use for the deployment | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC to deploy the components within | `string` | n/a | yes |
| <a name="input_iam_permissions_boundary"></a> [iam\_permissions\_boundary](#input\_iam\_permissions\_boundary) | The permissions boundary ARN to set on IAM roles created | `string` | `""` | no |
| <a name="input_telemetry_enabled"></a> [telemetry\_enabled](#input\_telemetry\_enabled) | Whether or not to send telemetry information back to Snowplow Analytics Ltd | `bool` | `true` | no |
| <a name="input_user_provided_id"></a> [user\_provided\_id](#input\_user\_provided\_id) | An optional unique identifier to identify the telemetry events emitted by this stack | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_collector_dns_name"></a> [collector\_dns\_name](#output\_collector\_dns\_name) | The ALB dns name for the Pipeline Collector |
