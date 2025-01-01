locals {
#   nfw_name       = format("%s-%s-nfw-%s-%02d", var.pj_tags.name, var.pj_tags.env, var.nfw.prefix, 1)
  nfw_rule_group_name = format("%s-%s-nfw-rulegrp-%s-%02d", var.pj_tags.name, var.pj_tags.env, var.nfw.rulegrp_name, 1)
}


resource "aws_networkfirewall_rule_group" "stateful" {
  capacity = 100
  name     = local.nfw_rule_group_name
  type     = "STATEFUL"
  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "DENYLIST"
        target_types         = ["HTTP_HOST"]
        targets              = ["test.example.com"]
      }
    }
  }

  tags = {
    Name = local.nfw_rule_group_name
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
}


resource "aws_networkfirewall_rule_group" "example" {
  capacity    = 100
  name        = "test"
  type        = "STATEFUL"

  rule_group {
    stateful_rule_options {
      rule_order = "STRICT_ORDER"
    }

    rule_variables {
      ip_sets {
        key = "IP_SET_ALLOW"
        ip_set {
          definition = [
            "10.0.1.0/24",
            "10.0.2.0/24",
          ]
        }
      }
      port_sets {
        key = "PORT_ALLOW"
        port_set {
          definition = [
            "80",
            "443",
          ]
        }
      }
    }

    rules_source {
      stateful_rule {
        header {
          destination      = "$IP_SET_ALLOW"
          destination_port = "$PORT_ALLOW"
          direction        = "FORWARD"
          protocol         = "TCP"
          source           = "ANY"
          source_port      = "ANY"
        }
        action = "PASS"
        rule_option {
          keyword  = "sid"
          settings = ["1"]
        }
      }
      stateful_rule {
        header {
          destination      = "ANY"
          destination_port = "ANY"
          direction        = "FORWARD"
          protocol         = "TCP"
          source           = "ANY"
          source_port      = "ANY"
        }
        action = "DROP"
        rule_option {
          keyword  = "sid"
          settings = ["2"]
        }
      }
      stateful_rule {
        header {
          destination      = "ANY"
          destination_port = "ANY"
          direction        = "FORWARD"
          protocol         = "UDP"
          source           = "ANY"
          source_port      = "ANY"
        }
        action = "DROP"
        rule_option {
          keyword  = "sid"
          settings = ["3"]
        }
      }
    }
  }

  # CloudFormationのDeletionPolicy/UpdateReplacePolicy相当の設定
  lifecycle {
    prevent_destroy = true
  }
}