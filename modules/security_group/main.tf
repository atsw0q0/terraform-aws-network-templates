resource "aws_security_group" "sg" {
  name        = format("%s-%s-sgp-%s-%02d", var.pj_tags.name, var.pj_tags.env, var.sg.prefix, 1)
  description = var.sg.description
  vpc_id      = var.sg.vpc_id
  tags = {
    Name = format("%s-%s-sgp-%s-%02d", var.pj_tags.name, var.pj_tags.env, var.sg.prefix, 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
  dynamic "ingress" {
    for_each = var.sg.ingress
    content {
      description     = lookup(ingress.value["description"], "description", "")
      from_port       = ingress.value["from_port"]
      to_port         = ingress.value["to_port"]
      protocol        = ingress.value["protocol"]
      cidr_blocks     = lookup(ingress.value["cidr_blocks"], "cidr_blocks", null)
      security_groups = lookup(ingress.value["security_groups"], "security_groups", null)
      prefix_list_ids = lookup(ingress.value["prefix_list_ids"], "prefix_list_ids", null)
      self            = lookup(ingress.value["self"], "self", null)
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
}
