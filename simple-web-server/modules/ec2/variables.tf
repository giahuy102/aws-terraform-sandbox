variable "private_subnet_ids" {
  type        = list(string)
  description = "Private Subnet ID values"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "common_tags" {
  type = map(string)
}

variable "sg_ingress_ports" {
  type = map(object({
    description = string
    port        = number
  }))

  default = {
    allow_http = {
      description = "Allow all HTTP traffics"
      port        = 80
    }
  }
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}
