# Elastic Beanstalk Instance Profile
resource "aws_iam_role" "aws-elasticbeanstalk-ec2-role" {
  name = "aws-elasticbeanstalk-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "aws-elasticbeanstalk-ec2-role" {
  name  = "aws-elasticbeanstalk-ec2-role"
  role = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
}

resource "aws_iam_role_policy_attachment" "aws-elasticbeanstalk-ec2-role-attachment-1" {
  role = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "aws-elasticbeanstalk-ec2-role-attachment-2" {
  role = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "aws-elasticbeanstalk-ec2-role-attachment-3" {
  role = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role_policy_attachment" "aws-elasticbeanstalk-ec2-role-attachment-4" {
  role = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
}

# Elastic Beanstalk Service Role
resource "aws_iam_role" "aws-elasticbeanstalk-service-role" {
  name = "aws-elasticbeanstalk-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "elasticbeanstalk"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws-elasticbeanstalk-service-role-attachment-1" {
  role = "${aws_iam_role.aws-elasticbeanstalk-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "aws-elasticbeanstalk-service-role-attachment-2" {
  role = "${aws_iam_role.aws-elasticbeanstalk-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

# RDS Monitoring Role
resource "aws_iam_role" "rds-monitoring-role" {
  name = "rds-monitoring-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "rds-monitoring-role-attachment-1" {
  role = "${aws_iam_role.rds-monitoring-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
