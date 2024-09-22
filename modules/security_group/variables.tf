variable "pj_tags" {
  type = object({
    name = string
    env  = string
  })
  default = {
    name = "hoge"
    env  = "test"
  }
}

variable "sg" {
  type = object({
    prefix      = string
    description = optional(string)
    vpc_id      = string
    ingress = map(object({
      description     = string
      from_port       = number
      to_port         = number
      cidr_blocks     = optional(list(string))
      security_groups = optional(list(string))
      prefix_list_ids = optional(list(string))
      self            = optional(string)
    }))
  })
  default = {
    prefix      = "ec2"
    description = "ec2"
    vpc_id      = "vpc_xxxxx"
    ingress     = {}
  }
}
