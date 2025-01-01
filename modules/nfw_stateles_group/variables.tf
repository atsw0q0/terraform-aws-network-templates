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

variable "nfw" {
  type = object({
    # prefix              = string
    rulegrp_name = string
    # is_enable_immutable = optional(bool, false)
    # vpc_id      = string
    # subnet_ids = list(string)
  })
  default = {
    # prefix              = "dmz"
    rulegrp_name = "stateful"
    # is_enable_immutable = false
    # vpc_id      = "vpc_xxxxx"
    # subnet_ids = ["subnet-xxx", "subnet-yyy"]
  }
}

