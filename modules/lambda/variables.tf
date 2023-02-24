variable "env" {}
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
variable "lambda_name" {
  type = map
}
# variable "cw_scheduler" {
#   type = map
# }
# variable "cw_scheduler" {
#     type = map(object({
#         tbc = bool
#       }))
#     }