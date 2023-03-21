# --- COMMON

resource "aws_key_pair" "pipeline" {
  key_name   = "${local.prefix}-pipeline"
  public_key = local.ssh_public_key
}

# --- BUCKETS

module "s3_pipeline_bucket" {
  source  = "snowplow-devops/s3-bucket/aws"
  version = "0.2.0"

  bucket_name = "${local.prefix}-pipeline"
}

# --- STREAMS

module "raw_stream" {
  source  = "snowplow-devops/kinesis-stream/aws"
  version = "0.3.0"

  name = "${local.prefix}-raw-stream"

  stream_mode_details = local.kinesis_stream_mode_details
}

module "bad_1_stream" {
  source  = "snowplow-devops/kinesis-stream/aws"
  version = "0.3.0"

  name = "${local.prefix}-bad-1-stream"

  stream_mode_details = local.kinesis_stream_mode_details
}

module "enriched_stream" {
  source  = "snowplow-devops/kinesis-stream/aws"
  version = "0.3.0"

  name = "${local.prefix}-enriched-stream"

  stream_mode_details = local.kinesis_stream_mode_details
}

# --- COLLECTOR

module "collector_lb" {
  source  = "snowplow-devops/alb/aws"
  version = "0.2.0"

  name              = "${local.prefix}-collector-lb"
  vpc_id            = local.vpc_id
  subnet_ids        = local.subnet_ids
  health_check_path = "/health"
}

module "collector_kinesis" {
  source  = "snowplow-devops/collector-kinesis-ec2/aws"
  version = "0.5.1"

  name               = "${local.prefix}-collector-server"
  vpc_id             = local.vpc_id
  subnet_ids         = local.subnet_ids
  collector_lb_sg_id = module.collector_lb.sg_id
  collector_lb_tg_id = module.collector_lb.tg_id
  ingress_port       = module.collector_lb.tg_egress_port
  good_stream_name   = module.raw_stream.name
  bad_stream_name    = module.bad_1_stream.name

  ssh_key_name     = aws_key_pair.pipeline.key_name
  ssh_ip_allowlist = local.ssh_ip_allowlist

  enable_auto_scaling = local.ec2_enable_auto_scaling
  min_size            = local.ec2_collector_min_size
  max_size            = local.ec2_collector_max_size
  instance_type       = local.ec2_collector_instance_type

  iam_permissions_boundary = var.aws_iam_permissions_boundary
  user_provided_id         = var.user_provided_id
  telemetry_enabled        = var.telemetry_enabled
}

# --- ENRICH

module "enrich_kinesis" {
  source  = "snowplow-devops/enrich-kinesis-ec2/aws"
  version = "0.5.1"

  name                 = "${local.prefix}-enrich-server"
  vpc_id               = local.vpc_id
  subnet_ids           = local.subnet_ids
  in_stream_name       = module.raw_stream.name
  enriched_stream_name = module.enriched_stream.name
  bad_stream_name      = module.bad_1_stream.name

  ssh_key_name     = aws_key_pair.pipeline.key_name
  ssh_ip_allowlist = local.ssh_ip_allowlist

  custom_iglu_resolvers = local.custom_iglu_resolvers

  enable_auto_scaling = local.ec2_enable_auto_scaling
  min_size            = local.ec2_enrich_min_size
  max_size            = local.ec2_enrich_max_size
  instance_type       = local.ec2_enrich_instance_type

  kcl_read_min_capacity  = local.dyndb_enrich_kcl_read_min_capacity
  kcl_read_max_capacity  = local.dyndb_enrich_kcl_read_max_capacity
  kcl_write_min_capacity = local.dyndb_enrich_kcl_write_min_capacity
  kcl_write_max_capacity = local.dyndb_enrich_kcl_write_max_capacity

  iam_permissions_boundary = var.aws_iam_permissions_boundary
  user_provided_id         = var.user_provided_id
  telemetry_enabled        = var.telemetry_enabled
}

# --- SNOWFLAKE LOADER

resource "aws_sqs_queue" "sf_message_queue" {
  content_based_deduplication = true
  kms_master_key_id           = "alias/aws/sqs"
  name                        = "${local.prefix}-sf-loader.fifo"
  fifo_queue                  = true
}

module "transformer_wrj" {
  source  = "snowplow-devops/transformer-kinesis-ec2/aws"
  version = "0.3.2"

  name       = "${local.prefix}-transformer-server-wrj"
  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids

  stream_name             = module.enriched_stream.name
  s3_bucket_name          = module.s3_pipeline_bucket.id
  s3_bucket_object_prefix = "transformed/good/widerow/json"
  window_period_min       = 1
  sqs_queue_name          = aws_sqs_queue.sf_message_queue.name

  transformation_type = "widerow"
  widerow_file_format = "json"

  ssh_key_name     = aws_key_pair.pipeline.key_name
  ssh_ip_allowlist = local.ssh_ip_allowlist

  custom_iglu_resolvers = local.custom_iglu_resolvers

  instance_type = local.ec2_transformer_instance_type

  kcl_read_min_capacity  = local.dyndb_transformer_kcl_read_min_capacity
  kcl_read_max_capacity  = local.dyndb_transformer_kcl_read_max_capacity
  kcl_write_min_capacity = local.dyndb_transformer_kcl_write_min_capacity
  kcl_write_max_capacity = local.dyndb_transformer_kcl_write_max_capacity

  iam_permissions_boundary = var.aws_iam_permissions_boundary
  user_provided_id         = var.user_provided_id
  telemetry_enabled        = var.telemetry_enabled
}

module "sf_loader" {
  source  = "snowplow-devops/snowflake-loader-ec2/aws"
  version = "0.2.1"

  name       = "${local.prefix}-sf-loader-server"
  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids

  sqs_queue_name = aws_sqs_queue.sf_message_queue.name

  snowflake_loader_user        = local.snowflake_loader_user
  snowflake_password           = var.snowflake_password
  snowflake_warehouse          = local.snowflake_warehouse
  snowflake_database           = local.snowflake_database
  snowflake_schema             = local.snowflake_schema
  snowflake_region             = local.snowflake_region
  snowflake_account            = local.snowflake_account
  snowflake_aws_s3_bucket_name = module.s3_pipeline_bucket.id

  ssh_key_name     = aws_key_pair.pipeline.key_name
  ssh_ip_allowlist = local.ssh_ip_allowlist

  custom_iglu_resolvers = local.custom_iglu_resolvers

  iam_permissions_boundary = var.aws_iam_permissions_boundary
  user_provided_id         = var.user_provided_id
  telemetry_enabled        = var.telemetry_enabled
}
