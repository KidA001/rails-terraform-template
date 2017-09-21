resource "aws_elastic_beanstalk_application" "application" {
  name = "${var.app_name}"
}

data "aws_elastic_beanstalk_solution_stack" "ruby" {
  most_recent = true

  name_regex = "^64bit Amazon Linux .+ Ruby .+ \\(Puma\\)$"
}

// STAGE
resource "aws_elastic_beanstalk_environment" "stage" {
  count = "${var.create_stage == true ? 1 : 0}"

  name = "${var.app_name}-stage"
  application = "${aws_elastic_beanstalk_application.application.name}"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.ruby.name}"

  setting {
    name = "MaxSize"
    namespace = "aws:autoscaling:asg"
    value = "1"
  }

  setting {
    name = "EC2KeyName"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "${var.app_name}"
  }

  setting {
    name = "IamInstanceProfile"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
  }

  setting {
    name = "InstanceType"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "t2.small"
  }

  setting {
    name = "SecurityGroups"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "${module.vpc.default_security_group_id}"
  }

  # https://github.com/terraform-providers/terraform-provider-aws/issues/1471
  # If uncommented, every `terraform apply` will result in environment update.
  //  setting {
  //    name = "SSHSourceRestriction"
  //    namespace = "aws:autoscaling:launchconfiguration"
  //    value = "tcp, 22, 22, ${aws_security_group.bastion.id}"
  //  }

  setting {
    name = "VPCId"
    namespace = "aws:ec2:vpc"
    value = "${module.vpc.vpc_id}"
  }

  setting {
    name = "Subnets"
    namespace = "aws:ec2:vpc"
    value = "${element(module.vpc.private_subnets, 0)}"
  }

  setting {
    name = "ELBSubnets"
    namespace = "aws:ec2:vpc"
    value = "${element(module.vpc.public_subnets, 0)}"
  }

  # TODO: Create a /health endpoint that returns 200, then uncomment this.
  # https://github.com/terraform-providers/terraform-provider-aws/issues/1471
  # If uncommented, every `terraform apply` will result in environment update.
  //  setting {
  //    name = "Application Healthcheck URL"
  //    namespace = "aws:elasticbeanstalk:application"
  //    value = "/health"
  //  }

  setting {
    name = "DATABASE_URL"
    namespace = "aws:elasticbeanstalk:application:environment"
    value = "${format("%v://%v:%v@%v/%v", aws_db_instance.stage.engine, aws_db_instance.stage.username, aws_db_instance.stage.password, aws_db_instance.stage.endpoint, aws_db_instance.stage.name)}"
  }

  setting {
    name = "REDIS_URL"
    namespace = "aws:elasticbeanstalk:application:environment"
    value = "${format("%v://%v:%v/12", aws_elasticache_replication_group.stage.engine, aws_elasticache_replication_group.stage.primary_endpoint_address, aws_elasticache_replication_group.stage.port)}"
  }

  setting {
    name = "StreamLogs"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    value = "true"
  }

  setting {
    name = "ServiceRole"
    namespace = "aws:elasticbeanstalk:environment"
    value = "${aws_iam_role.aws-elasticbeanstalk-service-role.name}"
  }

  setting {
    name = "SystemType"
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    value = "enhanced"
  }

  # TODO: Create ACM certificate, then uncomment this.
  //  setting {
  //    name = "LoadBalancerHTTPSPort"
  //    namespace = "aws:elb:loadbalancer"
  //    value = "443"
  //  }
  //
  //  setting {
  //    name = "SSLCertificateId"
  //    namespace = "aws:elb:loadbalancer"
  //    value = "${var.stage_acm_certificate_arn}"
  //  }
}

// PROD
resource "aws_elastic_beanstalk_environment" "prod" {
  count = "${var.create_prod == true ? 1 : 0}"

  name = "${var.app_name}-prod"
  application = "${aws_elastic_beanstalk_application.application.name}"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.ruby.name}"

  setting {
    name = "MinSize"
    namespace = "aws:autoscaling:asg"
    value = "2"
  }

  setting {
    name = "EC2KeyName"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "${var.app_name}"
  }

  setting {
    name = "IamInstanceProfile"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
  }

  setting {
    name = "InstanceType"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "m4.xlarge"
  }

  setting {
    name = "SecurityGroups"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "${module.vpc.default_security_group_id}"
  }

  # https://github.com/terraform-providers/terraform-provider-aws/issues/1471
  # If uncommented, every `terraform apply` will result in environment update.
  //  setting {
  //    name = "SSHSourceRestriction"
  //    namespace = "aws:autoscaling:launchconfiguration"
  //    value = "tcp, 22, 22, ${aws_security_group.bastion.id}"
  //  }

  setting {
    name = "VPCId"
    namespace = "aws:ec2:vpc"
    value = "${module.vpc.vpc_id}"
  }

  setting {
    name = "Subnets"
    namespace = "aws:ec2:vpc"
    value = "${join(",", module.vpc.private_subnets)}"
  }

  setting {
    name = "ELBSubnets"
    namespace = "aws:ec2:vpc"
    value = "${join(",", module.vpc.public_subnets)}"
  }

  # TODO: Create a /health endpoint that returns 200, then uncomment this.
  # https://github.com/terraform-providers/terraform-provider-aws/issues/1471
  # If uncommented, every `terraform apply` will result in environment update.
  //  setting {
  //    name = "Application Healthcheck URL"
  //    namespace = "aws:elasticbeanstalk:application"
  //    value = "/health"
  //  }

  setting {
    name = "DATABASE_URL"
    namespace = "aws:elasticbeanstalk:application:environment"
    value = "${format("%v://%v:%v@%v/%v", aws_db_instance.prod.engine, aws_db_instance.prod.username, aws_db_instance.prod.password, aws_db_instance.prod.endpoint, aws_db_instance.prod.name)}"
  }

  setting {
    name = "REDIS_URL"
    namespace = "aws:elasticbeanstalk:application:environment"
    value = "${format("%v://%v:%v/12", aws_elasticache_replication_group.prod.engine, aws_elasticache_replication_group.prod.primary_endpoint_address, aws_elasticache_replication_group.prod.port)}"
  }

  setting {
    name = "StreamLogs"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    value = "true"
  }

  setting {
    name = "ServiceRole"
    namespace = "aws:elasticbeanstalk:environment"
    value = "${aws_iam_role.aws-elasticbeanstalk-service-role.name}"
  }

  setting {
    name = "SystemType"
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    value = "enhanced"
  }

  setting {
    name = "CrossZone"
    namespace = "aws:elb:loadbalancer"
    value = "true"
  }

  # TODO: Create ACM certificate, then uncomment this.
  //  setting {
  //    name = "LoadBalancerHTTPSPort"
  //    namespace = "aws:elb:loadbalancer"
  //    value = "443"
  //  }
  //
  //  setting {
  //    name = "SSLCertificateId"
  //    namespace = "aws:elb:loadbalancer"
  //    value = "${var.prod_acm_certificate_arn}"
  //  }

  setting {
    name = "ConnectionDrainingEnabled"
    namespace = "aws:elb:policies"
    value = "true"
  }
}
