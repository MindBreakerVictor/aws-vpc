resource "aws_network_acl" "public" {
  count = var.mode != "public" ? 0 : 1

  vpc_id     = var.vpc_id
  subnet_ids = [for subnet in aws_subnet.public : subnet.id]

  dynamic "ingress" {
    for_each = lookup(var.network_acl_rules, "inbound", [])
    iterator = rule

    content {
      rule_no    = rule.value["rule_no"]
      protocol   = rule.value["protocol"]
      from_port  = rule.value["from_port"]
      to_port    = rule.value["to_port"]
      icmp_type  = lookup(rule.value, "icmp_type", null)
      icmp_code  = lookup(rule.value, "icmp_code", null)
      cidr_block = rule.value["cidr_block"]
      action     = rule.value["action"]
    }
  }

  dynamic "egress" {
    for_each = lookup(var.network_acl_rules, "outbound", [])
    iterator = rule

    content {
      rule_no    = rule.value["rule_no"]
      protocol   = rule.value["protocol"]
      from_port  = rule.value["from_port"]
      to_port    = rule.value["to_port"]
      icmp_type  = lookup(rule.value, "icmp_type", null)
      icmp_code  = lookup(rule.value, "icmp_code", null)
      cidr_block = rule.value["cidr_block"]
      action     = rule.value["action"]
    }
  }

  tags = merge(var.tags, { Name = "${var.derived_prefix}-public-nacl" })
}
