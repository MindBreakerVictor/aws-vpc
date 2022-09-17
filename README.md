# aws-vpc

> Terraform module for creating and managing AWS Virtual Private Cloud (VPC).

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
- [ ] IPv6 support
- [ ] Multiple IPv4 & IPv6 CIDR blocks support via BYOIP pools
- [ ] Multiple IPv4 & IPv6 CIDR blocks via IPAM pools (Amazon IP Address Manager)
- [ ] Local Zones support
- [ ] Wavelength Zones support

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_flow_log"></a> [flow\_log](#module\_flow\_log) | ./modules/flow-log | n/a |
| <a name="module_public_infra"></a> [public\_infra](#module\_public\_infra) | ./modules/public-infra | n/a |
| <a name="module_subnet_addresses"></a> [subnet\_addresses](#module\_subnet\_addresses) | ./modules/subnet-addresses | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | VPC name. | `string` | n/a | yes |
| <a name="input_main_cidr_block"></a> [main\_cidr\_block](#input\_main\_cidr\_block) | Main IPv4 CIDR block for the VPC. | `string` | n/a | yes |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | Tenancy of instances launched into the VPC. Dedicated or host tenancy cost at least 2$/h. | `string` | `"default"` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Whether to enable DNS support in the VPC. | `bool` | `true` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Whether to enable DNS hostnames in the VPC. | `bool` | `true` | no |
| <a name="input_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#input\_ipv6\_cidr\_block) | Whether to request an Amazon-provider IPv6 CIDR block with /56 prefix length for the VPC. | `bool` | `false` | no |
| <a name="input_availability_zones_count"></a> [availability\_zones\_count](#input\_availability\_zones\_count) | Number of Availability Zones to use for VPC subnets. | `number` | `3` | no |
| <a name="input_subnetting_algorithm"></a> [subnetting\_algorithm](#input\_subnetting\_algorithm) | Algorithm type for subnetting the VPC IPv4 CIDR blocks.<br>Supported algorithms:<br>* nowaste - Use the whole CIDR block, leaving no subnet addresses unused.<br>            It attempts an equal split. When the number of subnets is not a power of 2, the last subnets will have bigger prefix lengths<br>            Ie. Less usable host IPs<br>* equalsplit - The subnets will be split equally - ie. same prefix length<br>               This will result in unused subnet addresses when the number of requested subnets is not a power of 2. | `string` | `"nowaste"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of IPv4 CIDR blocks to use for each subnet, both private and public.<br>The # of subnets created is not decide by the length of the `private` & `public` lists, but rather the value of `availability_zones_count`,<br>but no more than the number of AZs available in the AWS Region where the VPC is created.<br>ie. min(var.availability\_zones\_count, length(data.aws\_availability\_zones.available.names))<br><br>If `private_subnets_only` is `true`, the `public` list can be passed as null or empty list.<br>By default, this variables is `null`, which means the subnets are computed by the internal algorithms, controlled by `subnetting_algorithm` variable. | <pre>object({<br>    private = list(string)<br>    public  = list(string)<br>  })</pre> | `null` | no |
| <a name="input_private_subnets_only"></a> [private\_subnets\_only](#input\_private\_subnets\_only) | Whether to create only private subnets from VPC IPv4 CIDR block. | `bool` | `false` | no |
| <a name="input_private_nacl_rules"></a> [private\_nacl\_rules](#input\_private\_nacl\_rules) | Inbound & outbound Network ACL rules for private subnets. | `any` | `{}` | no |
| <a name="input_public_nacl_rules"></a> [public\_nacl\_rules](#input\_public\_nacl\_rules) | Inbound & outbound Network ACL rules for public subnets. | `any` | `{}` | no |
| <a name="input_nat_gateway_setup"></a> [nat\_gateway\_setup](#input\_nat\_gateway\_setup) | NAT Gateway setup. Available options: one-az, failover, ha | `string` | `"ha"` | no |
| <a name="input_force_internet_gateway"></a> [force\_internet\_gateway](#input\_force\_internet\_gateway) | Force creation of an Internet Gateway for a VPC with only private subnets. Required if an AWS Global Accelerator is pointing to a private resource in the VPC. | `bool` | `false` | no |
| <a name="input_flow_logs_config"></a> [flow\_logs\_config](#input\_flow\_logs\_config) | Config block for VPC Flow Logs. It must be a map with the following optional keys: destination, retention, aggregation\_interval, kms\_key\_id.<br><br>Properties allowed values:<br>  destination          => "cloud-watch-logs" or "s3"<br>                          Default: "cloud-watch-logs"<br>  retention            => 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, 0 (indefinetely)<br>                          Default: 30 (days)<br>                          Valid only for CloudWatch destination<br>  aggregation\_interval => 60 or 600<br>                          Default: 600<br>  log\_format           => Check AWS documentation<br>  kms\_key\_id           => ARN of a CMK in AWS KMS<br>                          Default: AWS managed key<br>  s3\_tiering           => configuration for S3 Intelligent-Tiering<br>                          Default: Archive access after 90 days & Deep Archive Access after 180 days<br>                          Pass this as `null` or with both properties set to 0 to disable S3 Intelligent-Tiering<br>    archive\_access       => Days after which data is tiered to ARCHIVE\_ACCESS<br>                            Default: 90<br>                            Pass as 0 to disable ARCHIVE\_ACCESS tiering<br>    deep\_archive\_access  => Days after which data is tiered to DEEP\_ARCHIVE\_ACCESS<br>                            Default: 180<br>                            Pass as 0 to disable DEEP\_ARCHIVE\_ACCESS tiering<br><br>Pass the variable as null to disable flow logs. | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags for all resources created by this module. Reserved tag keys: Name, net/type | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The VPC ID. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Map of both private & public subnets with IP CIDR block, associated route table & network ACL IDs as properties. |
| <a name="output_private_subnet_addresses"></a> [private\_subnet\_addresses](#output\_private\_subnet\_addresses) | n/a |
| <a name="output_public_subnet_addresses"></a> [public\_subnet\_addresses](#output\_public\_subnet\_addresses) | n/a |
| <a name="output_unused_subnet_addresses"></a> [unused\_subnet\_addresses](#output\_unused\_subnet\_addresses) | n/a |
<!-- END_TF_DOCS -->

## TODOs

- [x] Terraform docs
- [x] Unit tests using Golang & GitHub Actions
- [x] Run tfsec & checkov within GitHub Actions

### Test scenarios

- [ ] Update from private-only VPC to public with 1, 2 or multi-AZ NAT Gateways and all combinations. Total cases: 6 + 2 + 2 + 2
- [ ] Update NACL rules. Total cases: 3
- [ ] Update private-only VPC to use or not IGW. Total cases: 2
- [ ] Disable/enable flow logs. Switch between destinations in flow logs. Total cases: 6
