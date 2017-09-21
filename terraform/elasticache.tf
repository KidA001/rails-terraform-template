resource "aws_elasticache_replication_group" "stage" {
  count = "${var.create_stage == true ? 1 : 0}"

  replication_group_id = "${var.app_name}-stage"
  replication_group_description = "${var.app_name}-stage"
  node_type = "cache.t2.small"
  number_cache_clusters = 1
  port = 6379
  parameter_group_name = "default.redis3.2"
  availability_zones = [
    "${element(var.vpc_private_azs, 0)}"
  ]

  apply_immediately = true
  subnet_group_name = "${module.vpc.elasticache_subnet_group}"
  security_group_ids = [
    "${module.vpc.default_security_group_id}"
  ]
}

resource "aws_elasticache_replication_group" "prod" {
  count = "${var.create_prod == true ? 1 : 0}"

  replication_group_id = "${var.app_name}-prod"
  replication_group_description = "${var.app_name}-prod"
  node_type = "cache.r3.large"
  number_cache_clusters = 3
  port = 6379
  parameter_group_name = "default.redis3.2"
  availability_zones = [
    "${var.vpc_private_azs}"
  ]
  automatic_failover_enabled = true

  apply_immediately = true
  subnet_group_name = "${module.vpc.elasticache_subnet_group}"
  security_group_ids = [
    "${module.vpc.default_security_group_id}"
  ]
  snapshot_retention_limit = 1
}
