VPC = {
    "name"                  = "VPC Development",
    "CIDR"                  = "192.3.0.0/16",
    "private_subnets"       = ["192.3.0.0/20",   "192.3.16.0/20",  "192.3.32.0/20"],
    "private_subnets"       = ["192.3.176.0/20", "192.3.177.0/20", "192.3.178.0/20"],
    "azs"                   = [],
    "enable_vpn_gateway"    = false,
    "public_subnets_tags"   = {},
    "private_subnets_tags"  = {},
    "aws_asn"               = 64650
}

#internal_zone = "aws.development"