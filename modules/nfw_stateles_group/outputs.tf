output "nfw_rule_group_arn" {
  value = aws_networkfirewall_rule_group.stateful.arn
}

output "nfw_rule_group_id" {
  value = aws_networkfirewall_rule_group.stateful.id
}
