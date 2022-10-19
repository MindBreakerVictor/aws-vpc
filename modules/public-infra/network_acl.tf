resource "aws_network_acl" "public" {
  count = var.mode != "public" ? 0 : 1

  vpc_id = var.vpc.id

  tags = merge(var.tags, { Name = "${var.vpc.name}-public" })
}

resource "aws_network_acl_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.public[0].id
}

resource "aws_network_acl_rule" "public" {
  for_each = toset(var.mode != "public" || var.empty_network_acl ? [] : ["ingress", "egress"])

  network_acl_id = aws_network_acl.public[0].id
  egress         = each.key == "egress"

  rule_number = 100
  protocol    = "all" # tfsec:ignore:aws-ec2-no-excessive-port-access
  from_port   = 0
  to_port     = 0
  cidr_block  = "0.0.0.0/0" # tfsec:ignore:aws-ec2-no-public-ingress-acl
  rule_action = "allow"
}
