resource "aws_key_pair" "key_pair" {
  key_name = "${var.app_name}"
  public_key = "${file("~/.ssh/${var.app_name}.pub")}"
}
