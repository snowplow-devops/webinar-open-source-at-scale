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
