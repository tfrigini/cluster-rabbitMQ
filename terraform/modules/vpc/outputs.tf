output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "List of private subnets"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "List of public subnets"
}

output "database_subnets" {
  value       = module.vpc.database_subnets
  description = "Database subnets"
}

output "cgw_ids" {
 value              = module.vpc.cgw_ids
 description        = "List of IDs of Customer Gateway" 
}

output "vgw_id" {
  value           = module.vpc.vgw_id
  description     = "The ID of the VPN Gateway"
}

output "private_route_table_ids" {
  value       = module.vpc.private_route_table_ids
  description = "List of IDs of private route tables"
}

output "database_subnet_group_name" {
  value       = module.vpc.database_subnet_group_name
  description = "Database subnet group name"
}