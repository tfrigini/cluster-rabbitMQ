VPC = {
    "name"                  = "VPC Development",
    "CIDR"                  = "192.0.0.0/16",
    "private_subnets"       = ["192.0.0.0/20",   "192.0.16.0/20",  "192.0.32.0/20"],
    "public_subnets"        = ["192.0.176.0/24", "192.0.177.0/24", "192.0.178.0/24"]
    "azs"                   = [],
    "enable_vpn_gateway"    = false,
    "public_subnets_tags"   = {},
    "private_subnets_tags"  = {},
    "aws_asn"               = 64650
}

#internal_zone = "aws.development"