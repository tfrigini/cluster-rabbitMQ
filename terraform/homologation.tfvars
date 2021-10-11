VPC = {
    "name"                  = "VPC Development",
    "CIDR"                  = "192.1.0.0/16",
    "private_subnets"       = ["192.1.0.0/20",   "192.1.16.0/20",  "192.1.32.0/20"],
    "public_subnets"        = ["192.1.176.0/20", "192.1.177.0/20", "192.1.178.0/20"],
    "azs"                   = [],
    "enable_vpn_gateway"    = false,
    "public_subnets_tags"   = {},
    "private_subnets_tags"  = {},
    "aws_asn"               = 64650
}

#internal_zone = "aws.homologation"