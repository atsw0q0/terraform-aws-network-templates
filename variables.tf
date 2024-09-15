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

variable "vpc_prefix" {
  type = object({
    prefix     = string
    cidr_block = string
  })
  default = {
    prefix     = "network"
    cidr_block = "10.0.0.0/16"
  }
}

variable "subnet" {
  type = map(map(object({
    prefix           = string
    cidr_block       = string
    az               = string
    is_public_subnet = bool
  })))
  default = {
    pub = {
      pub_a = {
        prefix           = "pub"
        cidr_block       = "10.0.0.0/24"
        az               = "a"
        is_public_subnet = true
      }
      pub_c = {
        prefix           = "pub"
        cidr_block       = "10.0.1.0/24"
        az               = "c"
        is_public_subnet = true
      }
    }
    pri = {
      pri_a = {
        prefix           = "pri"
        cidr_block       = "10.0.10.0/24"
        az               = "a"
        is_public_subnet = false
      }
      pri_c = {
        prefix           = "pri"
        cidr_block       = "10.0.11.0/24"
        az               = "c"
        is_public_subnet = false
      }
    }
    edp = {
      edp_a = {
        prefix           = "edp"
        cidr_block       = "10.0.20.0/24"
        az               = "a"
        is_public_subnet = false
      }
      edp_c = {
        prefix           = "edp"
        cidr_block       = "10.0.21.0/24"
        az               = "c"
        is_public_subnet = false
      }
    }
  }
}

