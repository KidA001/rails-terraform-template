variable "app_name" {}

variable "create_stage" {
  default = false
}
variable "create_prod" {
  default = false
}

variable "stage_acm_certificate_arn" {}

variable "prod_acm_certificate_arn" {}
