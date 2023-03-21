locals {
  # --- Change this to a unique value to avoid conflicts
  prefix = "sp-osatscale"

  # --- Network settings (fetch these from the AWS console)
  vpc_id = "vpc-07f29d40eb1905e46"
  subnet_ids = [
    "subnet-0ccc4ee3ff14a876d",
    "subnet-0a32533d33614298b",
    "subnet-0e590635d36d4f023"
  ]

  # --- The IP Address that you will be accessing servers from (your public IPv4 address)
  ssh_ip_allowlist = [
    "54.66.204.91/32"
  ]

  # --- Change this to your own SSH Public Key for access to the servers over SSH
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOKjtQQavckbl5tzdUv8kZbCCnb16uWWksp8J6tkZfA/HZdFAj04Hs0gV17pZSZoQMxLmflVBegsOKqWmXtp4pGpWk0T+dmSYRK5AV8+J+5NiIJcaEDKVTpV3nVzDIpgMmHprH+HEJiGU7jggsUIMxOPc61jcq7SeVe2GAr8HJ3M1EXf7PNAUanimHNM0IvuTOskhGJCpFihUqbpa480wR0tjS7EMg52yFOtyOsXZh6Quzljtoh/xLzsLgLR3YL/6Ulk56SApF2eiXPvGC8qoSmKbLH8x8AyqnBoXOvkv8riP809m1aIzC5TGKm0U2iAPfbuC3bdJ2oZtC+0FOvm4Y8t+BOpz8UvVHHzbVvZGM/Pm9kKMWF6NKHmWgXROtkiGnVb+EyNplGWqCbSs3tOhhGVkssm+9J0gafF8Co1+9tQz3xIwGkwUIvfvVe0ZoDEZZJBeU/6Zuq4CUEBkndPUyaNhDYNEFg81iVuTByfNP5ZNsAPKrMtmCu6uzN5cyCxgzZsE9EknWNYueBp2bIz12N7z8QWHguUCzY1XGNxJIwPoLz83wTWMEe8RX0//gB9ELtw8I1IeiqYF024EZVQHOIaunt8eRJ73AEYQKNFM1tDNfoHtp0G009QV+lW6Z0WqkvNhBu4P2Qr3ub2pWzvWwmw6AiFKUd546tgOWti6Dnw== jbeemster@Joshuas-MacBook-Pro.local"

  # --- Snowflake settings (Note: update these to your own values!)
  snowflake_loader_user = "JOSHB_OS_USER"
  snowflake_warehouse   = "JOSHB_OS_WH"
  snowflake_database    = "JOSHB_OS_DB"
  snowflake_schema      = "ATOMIC"
  snowflake_region      = "us-west-2"
  snowflake_account     = "snowplow"

  # --- Kinesis scaling options
  kinesis_stream_mode_details = "PROVISIONED" # Change to: "ON_DEMAND" to have it auto-scale

  # --- EC2 scaling options
  ec2_enable_auto_scaling = false # Change to: "true" to have EC2 groups auto-scale based on CPU

  # EC2 settings for Collector
  ec2_collector_min_size      = 1
  ec2_collector_max_size      = 2
  ec2_collector_instance_type = "t3a.micro"

  # EC2 settings for Enrich
  ec2_enrich_min_size      = 1
  ec2_enrich_max_size      = 2
  ec2_enrich_instance_type = "t3a.small"
  # DynamoDB setting which controls how fast the Enrich KCL can checkpoint records
  dyndb_enrich_kcl_read_min_capacity  = 1
  dyndb_enrich_kcl_read_max_capacity  = 5
  dyndb_enrich_kcl_write_min_capacity = 1
  dyndb_enrich_kcl_write_max_capacity = 5

  # EC2 settings for Transformer (Note: there is only vertical scaling available safely here so no auto-scaling)
  ec2_transformer_instance_type = "t3a.small"
  # DynamoDB setting which controls how fast the Enrich KCL can checkpoint records
  dyndb_transformer_kcl_read_min_capacity  = 1
  dyndb_transformer_kcl_read_max_capacity  = 5
  dyndb_transformer_kcl_write_min_capacity = 1
  dyndb_transformer_kcl_write_max_capacity = 5
}
