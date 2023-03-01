variable "env" {}
variable "python_v" {}
variable "timeout" {
  default = 10
}

variable "cw_scheduler" {
  type = bool
  default = false
}

variable "lambda" {
  type = map(object({
    name     = string
    policy   = string
    schedule = string
  }))
}