resource "aws_network_acl" "private" {
  vpc_id     = local.vpc_id
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = merge(var.tags, { Name = "${var.name}-private" })
}

resource "aws_network_acl_rule" "private" {
  for_each = toset(var.empty_network_acls ? [] : ["ingress", "egress"])

  network_acl_id = aws_network_acl.private.id
  egress         = each.key == "egress"

  rule_number = 100
  protocol    = "all" # tfsec:ignore:aws-ec2-no-excessive-port-access
  from_port   = 0
  to_port     = 0
  cidr_block  = "0.0.0.0/0" # tfsec:ignore:aws-ec2-no-public-ingress-acl
  rule_action = "allow"
}
