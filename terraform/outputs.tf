output "bastion_public_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "stage_database_url" {
  value = "${var.create_stage == true ? format("%v://%v:%v@%v/%v", aws_db_instance.stage.engine, aws_db_instance.stage.username, aws_db_instance.stage.password, aws_db_instance.stage.endpoint, aws_db_instance.stage.name): ""}"
}

output "stage_redis_url" {
  value = "${var.create_stage == true ? format("%v://%v:%v/12", aws_elasticache_replication_group.stage.engine, aws_elasticache_replication_group.stage.primary_endpoint_address, aws_elasticache_replication_group.stage.port): ""}"
}

output "prod_database_url" {
  value = "${var.create_prod == true ? format("%v://%v:%v@%v/%v", aws_db_instance.prod.engine, aws_db_instance.prod.username, aws_db_instance.prod.password, aws_db_instance.prod.endpoint, aws_db_instance.prod.name): ""}"
}

output "prod_redis_url" {
  value = "${var.create_prod == true ? format("%v://%v:%v/12", aws_elasticache_replication_group.prod.engine, aws_elasticache_replication_group.prod.primary_endpoint_address, aws_elasticache_replication_group.prod.port): ""}"
}
