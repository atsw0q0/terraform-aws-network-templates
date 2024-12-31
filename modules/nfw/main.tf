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


# resource "aws_networkfirewall_firewall" "main" {
#   name                = local.nfw_name
#   vpc_id              = var.nfw.vpc_id

#   dynamic "subnet_mappings" {
#     for_each = var.nfw.subnet_ids
#     content {
#       subnet_id = subnet_mappings.value
#     }
#   }
# #   firewall_policy_arn = aws_networkfirewall_firewall_policy.example.arn
# }

# resource "aws_networkfirewall_firewall_policy" "example" {
#   name = "example-firewall-policy"
#   firewall_policy {
#     stateless_default_actions = ["aws:pass"]
#     stateless_fragment_default_actions = ["aws:drop"]

#     stateful_rule_group_reference {
#       resource_arn = aws_networkfirewall_rule_group.example.arn
#     }
#   }
# }

# resource "aws_networkfirewall_rule_group" "example" {
#   capacity = 100
#   name     = "example-rule-group"
#   type     = "STATEFUL"

#   rule_group {
#     rules_source {
#       rules_string = <<EOF
# pass tcp any any -> any 80 (msg:"Allow HTTP"; flow:established,to_server; sid:1; rev:1;)
# EOF
#     }
#   }
# }



# # ECR
# locals {
#   repository_name       = format("%s-%s-ecr-%s-%02d", var.pj_tags.name, var.pj_tags.env, var.ecr.prefix, 1)
# }

# resource "aws_ecr_repository" "repo" {
#   name                 = local.repository_name
#   image_tag_mutability = var.ecr.is_enable_immutable ? "IMMUTABLE" : "MUTABLE"
#   encryption_configuration {
#     encryption_type = "AES256"
#   }
#   image_scanning_configuration {
#     scan_on_push = true
#   }
#   tags = {
#     Name = local.repository_name
#     PJ   = var.pj_tags.name
#     Env  = var.pj_tags.env
#   }
# }