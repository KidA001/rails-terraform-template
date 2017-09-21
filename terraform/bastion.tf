data "aws_ami" "bastion" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2"
    ]
  }

  name_regex = "^^amzn-ami-hvm-\\d{4}\\.\\d{2}\\.\\d+\\..+x86_64-gp2"
}

resource "aws_security_group" "bastion" {
  name = "bastion"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      # Boston Primary
      "104.207.209.218/32",
      # Boston Secondary
      "50.247.199.97/32",
      # Oakland Primary
      "199.101.129.138/32"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  vpc_id = "${module.vpc.vpc_id}"

  tags {
    Name = "bastion"
  }
}

resource "aws_instance" "bastion" {
  ami = "${data.aws_ami.bastion.id}"
  availability_zone = "${element(var.vpc_private_azs, 0)}"
  instance_type = "t2.micro"
  key_name = "${var.app_name}"
  vpc_security_group_ids = [
    "${module.vpc.default_security_group_id}",
    "${aws_security_group.bastion.id}"
  ]
  subnet_id = "${element(module.vpc.public_subnets, 0)}"

  tags {
    Name = "bastion"
  }
}
