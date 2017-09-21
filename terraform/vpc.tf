// http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/vpc-bastion-host.html

variable "vpc_private_azs" {
  type = "list"
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.app_name}"

  cidr = "10.0.0.0/16"

  azs = "${var.vpc_private_azs}"
  private_subnets = [
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
  public_subnets = [
    "10.0.10.0/24",
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
  database_subnets = [
    "10.0.20.0/24",
    "10.0.21.0/24",
    "10.0.22.0/24"
  ]
  elasticache_subnets = [
    "10.0.30.0/24",
    "10.0.31.0/24",
    "10.0.32.0/24"
  ]

  enable_dns_support = true

  enable_nat_gateway = true

  enable_s3_endpoint = true
}
