# aws-vpc

Terraform module for creating and managing AWS Virtual Private Cloud (VPC).

## Features

- [x] Auto subnetting with 2 algorithms available (see subnet-addresses submodule)
- [x] VPC & Subnets
- [x] Delete rules from VPC default Network ACL & Security Group
- [x] Custom Network ACL & Route Table(s) for private subnets
- [x] Public infrastructure (see public-infra submodule)
  - [x] Internet Gateway
  - [x] NAT Gateway(s) with 3 setups available  
        `one-az` - only one NAT Gateway shared by all subnets across all AZs  
        `failover` - two NAT Gateways in different AZs one is used like in `one-az` setup and one is ready for failover  
        `ha` - high availability setup; each AZ has its own NAT Gateway, this setup is considerably pricier)
  - [x] Subnets
  - [x] Custom Network ACL & Route Table for public subnets
- [ ] VPC Endpoints
  - [x] Gateway endpoints for S3 & DynamoDB services
  - [ ] Interface endpoints for supported AWS services
- [x] Flow logs
- [ ] Terraform docs
- [ ] Unit tests using Golang & GitHub Actions
- [ ] Run tfsec & checkov within GitHub Actions
- [ ] Multiple IPv4 CIDR blocks support
- [ ] IPv6 support

## Test scenarios

- Update from private-only VPC to public with 1, 2 or multi-AZ NAT Gateways and all combinations. Total cases: 6 + 2 + 2 + 2
- Update NACL rules. Total cases: 3
- Update private-only VPC to use or not IGW. Total cases: 2
- Disable/enable flow logs. Switch between destinations in flow logs. Total cases: 6
