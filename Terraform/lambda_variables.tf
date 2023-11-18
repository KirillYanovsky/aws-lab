variable "name" {
  description = "Prefix for resources name"
  default     = "ec2-scheduler"
}

variable "stop_cron_schedule" {
  description = "Cron Expression when to STOP Servers in UTC Time zone"
  default     = "cron(18 00 * * ? *)"
}

variable "start_cron_schedule" {
  description = "Cron Expression when to START Servers in UTC Time zone"
  default     = "cron(13 10 * * ? *)"
}

variable "tags" {
  description = "Tags to apply to resources"
  default = {
    Name      = "AWS-lab"
    Terraform = "true"
  }
}
