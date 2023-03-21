# Webinar: Open source at Scale

This repo contains example Terraform code for deploying a base pipeline in AWS that loads data into Snowflake as well as detailing the core settings that you need to tweak to get the pipeline to scale up.

## Usage

1. You will need to configure a Snowflake destination - you can follow the instructions noted [here](https://github.com/snowplow-devops/terraform-aws-snowflake-loader-ec2#usage) which will guide you through how to configure your Snowflake instance
2. Update the `locals.tf` with your personal Snowflake settings and note the "password" seperately as this will be an input for the module
3. 