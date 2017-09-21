resource "aws_db_instance" "stage" {
  count = "${var.create_stage == true ? 1 : 0}"

  allocated_storage = 100
  storage_type = "gp2"
  engine = "postgres"
  instance_class = "db.t2.small"
  name = "${var.app_name}"
  username = "awsusername"
  password = "awspassword"
  db_subnet_group_name = "${module.vpc.database_subnet_group}"

  identifier = "${var.app_name}-stage"
  final_snapshot_identifier = "${var.app_name}-stage-final"
  vpc_security_group_ids = [
    "${module.vpc.default_security_group_id}"
  ]

  apply_immediately = true
  availability_zone = "${element(var.vpc_private_azs, 0)}"
  backup_retention_period = 7
  monitoring_interval = 60
  monitoring_role_arn = "${aws_iam_role.rds-monitoring-role.arn}"
}

resource "aws_db_instance" "prod" {
  count = "${var.create_prod == true ? 1 : 0}"

  allocated_storage = 100
  storage_type = "gp2"
  engine = "postgres"
  instance_class = "db.m4.xlarge"
  name = "${var.app_name}"
  username = "awsusername"
  password = "awspassword"
  db_subnet_group_name = "${module.vpc.database_subnet_group}"

  identifier = "${var.app_name}-prod"
  final_snapshot_identifier = "${var.app_name}-prod-final"
  vpc_security_group_ids = [
    "${module.vpc.default_security_group_id}"
  ]

  apply_immediately = true
  backup_retention_period = 7
  monitoring_interval = 60
  monitoring_role_arn = "${aws_iam_role.rds-monitoring-role.arn}"

  multi_az = true
  storage_type = "io1"
  iops = 1000
}
