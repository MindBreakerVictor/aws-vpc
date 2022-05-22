# subnet-addresses

This submodule only splits an IPv4 supernet, ie. Amazon VPC IPv4 CIDR block, into multiple subnets, based on the parameters given.

It uses two algorithms to do the subnetting:

* nowaste - uses the whole CIDR block and as a consequence the netmask won't be equal for all subnets, depending on the number of subnets
* equalsplit - uses the same netmaks for all subnets and as a consequence some of the IP space might be left unused, depending on the number of subnets

The module takes as input the number of Availability Zones to be used in an AWS Region and whether the VPC will have only private subnets only or not.
Based on that it calculates how many subnets are required: `subnets_count = availability_zones * (private_subnets_only ? 1 : 2)`

Since IPv4 addresses' netmasks are internally represented as bits, the math in the module is based on the powers of 2.

## nowaste algorithm

The algorithm's purpose is to leave no unused IP address. Steps to achieve that:

1. Split the CIDR block in the biggest equal subnets.
2. Take each subnet in the list and split it again (starting from the end of the list) until we get the desired number of subnets

## Example

Splitting 10.0.0.0/16 into 12 subnets; 6 AZs in us-east-1 region: 2 sets of subnets, one public, one private

<!-- markdownlint-disable MD033 -->
<details>
  <summary><b>Step 1</b></summary>

  ```txt
  10.0.0.0/19  
  10.0.32.0/19  
  10.0.64.0/19  
  10.0.96.0/19  
  10.0.128.0/19  
  10.0.160.0/19  
  10.0.192.0/19  
  10.0.224.0/19
  ```

  We can see from a /16 net that we want to get 12 subnets, the best we can do at step 1 is 8 equal subnets, if we were to split them again in equal subnets,
  we would have gotten 16 (remember, powers of 2) which is more than we need, but this algorithm doesn't want to leave anything on the table.  
  So we are extending the VPC CIDR block prefix by 3 (2 ^ (19 - 16) = 8). Remember this when looking at the `Math` section.
</details>

<details>
  <summary><b>Step 2</b></summary>

  From the back of the list we start to split each subnet again to get the number of subnets we want.
  We got 8 subnets so far, so 4 more to go, which means we only need to split the last 4 subnets in /20s.

  ```txt
  10.0.128.0/19
    10.0.128.0/20
    10.0.144.0/20
  10.0.160.0/19
    10.0.160.0/20
    10.0.176.0/20
  10.0.192.0/19
    10.0.192.0/20
    10.0.208.0/20
  10.0.224.0/19
    10.0.224.0/20
    10.0.240.0/20
  ```

</details>

<details>
  <summary><b>Final result</b></summary>

  ```txt
  10.0.0.0/16
    10.0.0.0/19
    10.0.32.0/19
    10.0.64.0/19
    10.0.96.0/19
    10.0.128.0/20
    10.0.144.0/20
    10.0.160.0/20
    10.0.176.0/20
    10.0.192.0/20
    10.0.208.0/20
    10.0.224.0/20
    10.0.240.0/20
  ```

</details>
<!-- markdownlint-enable MD033 -->

## Math

### Step 1

For splitting the subnets in as many equal subnets possible, we need the smallest exponent of 2 for which: `2 ^ exp <= subnets_count < 2 ^ (exp + 1)`  
To do so, we use the floor of the logarithm: `smallest_bits_to_extend_prefix = floor(log(subnets_count, 2))`

Then we can calculate the subnets as: `initial_cidr_blocks = [for netnum in range(0, pow(2, smallest_bits_to_extend_prefix)) : cidrsubnet(vpc_cidr_block, smallest_bits_to_extend_prefix, netnum)]`

### Step 2

```hcl
last_cidr_blocks_to_split = reverse(slice(reverse(initial_cidr_blocks), 0, subnets_counts - length(initial_cidr_blocks)))
last_cidr_blocks_splitted = [ for net in last_cidr_blocks_to_split : cidrsubnets(net, 1, 1)] # split in two subnets each with prefix extended by 1 bit

subnet_addresses = concat(
  slice(initial_cidr_blocks, 0, length(initial_cidr_blocks) - length(last_cidr_blocks_to_split)),
  last_cidr_blocks_splitted
)
```

## equalsplit algorithm

The purpose of this algorithm is to compute all the required subnets with equal address space, ie. same net prefix.  
To achieve this we just need the power of 2 greater-or-equal to the desired number of subnets, ie. `biggest_bits_to_extend_prefix = ceil(log(subnets_count, 2))`  
We then use the first subnets_count subnets: `[for netnum in range(0, subnets_count) : cidrsubnet(vpc_cidr_block, biggest_bits_to_extend_prefix, netnum)]`
