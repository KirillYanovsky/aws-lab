variable "name" {
  description = "Prefix for resources name"
  type        = string
  default     = "ec2-scheduler"
}

variable "stop_cron_schedule" {
  description = "Cron Expression when to STOP Servers in UTC Time zone"
  type        = string
  default     = "cron(15 18 * * ? *)"
}

variable "start_cron_schedule" {
  description = "Cron Expression when to START Servers in UTC Time zone"
  type        = string
  default     = "cron(13 10 * * ? *)"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Name      = "AWS-lab"
    Terraform = "true"
  }
}
