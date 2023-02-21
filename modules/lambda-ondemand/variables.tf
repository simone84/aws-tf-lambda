variable "env" {}
variable "lambda_name" {}
variable "python_v" {}
variable "timeout" {
  default = 10
}
variable "cw_scheduler" {
  type = bool
  default = false  
}
variable "schedule" {
 default = "rate(60 minutes)"
}