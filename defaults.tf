locals {
  # Defaults used across the module
  defaults = {
    private_nacl_rules = {
      inbound = [
        # Allow all inbound traffic inside the VPC
        {
          rule_no    = 100
          protocol   = "-1"
          from_port  = 0
          to_port    = 0
          cidr_block = var.main_cidr_block
          action     = "allow"
        },
        # Deny MS SQL from Internet
        {
          rule_no    = 200
          protocol   = "tcp"
          from_port  = 1433
          to_port    = 1433
          cidr_block = "0.0.0.0/0"
          action     = "deny"
        },
        # Deny Oracle from Internet
        {
          rule_no    = 300
          protocol   = "tcp"
          from_port  = 1521
          to_port    = 1521
          cidr_block = "0.0.0.0/0"
          action     = "deny"
        },
        # Deny MySQL/Aurora from Internet
        {
          rule_no    = 400
          protocol   = "tcp"
          from_port  = 3306
          to_port    = 3306
          cidr_block = "0.0.0.0/0"
          action     = "deny"
        },
        # Deny RDP from Internet
        {
          rule_no    = 500
          protocol   = "tcp"
          from_port  = 3389
          to_port    = 3389
          cidr_block = "0.0.0.0/0"
          action     = "deny"
        },
        # Deny PostgreSQL from Internet
        {
          rule_no    = 600
          protocol   = "tcp"
          from_port  = 5432
          to_port    = 5432
          cidr_block = "0.0.0.0/0"
          action     = "deny"
        },
        # Deny Redshift from Internet
        {
          rule_no    = 700
          protocol   = "tcp"
          from_port  = 5439
          to_port    = 5439
          cidr_block = "0.0.0.0/0"
          action     = "deny"
        },
        # Allow 1024-65535 TCP inbound from Internet
        {
          rule_no    = 1000
          protocol   = "tcp"
          from_port  = 1024
          to_port    = 65535
          cidr_block = "0.0.0.0/0"
          action     = "allow"
        }
      ]

      outbound = [
        # Allow all TCP outbound
        {
          rule_no    = 100
          protocol   = "tcp"
          from_port  = 0
          to_port    = 65535
          cidr_block = "0.0.0.0/0"
          action     = "allow"
        }
      ]
    }

    public_nacl_rules = {
      inbound = [
        # Allow HTTP inbound traffic inside the VPC
        {
          rule_no    = 100
          protocol   = "tcp"
          from_port  = 80
          to_port    = 80
          cidr_block = var.main_cidr_block
          action     = "allow"
        },
        # Allow HTTPS inbound traffic from the Internet
        {
          rule_no    = 150
          protocol   = "tcp"
          from_port  = 443
          to_port    = 443
          cidr_block = "0.0.0.0/0"
          action     = "allow"
        },
        # Deny MS SQL from Internet
        {
          rule_no    = 200
          protocol   = "tcp"
          from_port  = 1433
          to_port    = 1433
          cidr_block = "0.0.0.0/0"
          action     = "deny"
        },
        # Deny Oracle from Internet
        {
          rule_no    = 300
          protocol   = "tcp"
          from_port  = 1521
          to_port    = 1521
          cidr_block = "0.0.0.0/0"
          action     = "deny"
        },
        # Deny MySQL/Aurora from Internet
        {
          rule_no    = 400
          protocol   = "tcp"
          from_port  = 3306
          to_port    = 3306
          cidr_block = "0.0.0.0/0"
          action     = "deny"
        },
        # Deny RDP from Internet
        {
          rule_no    = 500
          protocol   = "tcp"
          from_port  = 3389
          to_port    = 3389
          cidr_block = "0.0.0.0/0"
          action     = "deny"
        },
        # Deny PostgreSQL from Internet
        {
          rule_no    = 600
          protocol   = "tcp"
          from_port  = 5432
          to_port    = 5432
          cidr_block = "0.0.0.0/0"
          action     = "deny"
        },
        # Deny Redshift from Internet
        {
          rule_no    = 700
          protocol   = "tcp"
          from_port  = 5439
          to_port    = 5439
          cidr_block = "0.0.0.0/0"
          action     = "deny"
        },
        # Allow 1024-65535 TCP inbound from Internet
        {
          rule_no    = 1000
          protocol   = "tcp"
          from_port  = 1024
          to_port    = 65535
          cidr_block = "0.0.0.0/0"
          action     = "allow"
        }
      ]

      outbound = [
        # Allow all TCP outbound
        {
          rule_no    = 100
          protocol   = "tcp"
          from_port  = 0
          to_port    = 65535
          cidr_block = "0.0.0.0/0"
          action     = "allow"
        }
      ]
    }
  }
}
