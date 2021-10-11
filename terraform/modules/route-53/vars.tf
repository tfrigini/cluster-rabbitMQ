variable "vpc_id" {
  description = "VPC id with DNS zone its attached"
  type = string
  default = null
}

variable "route53_zone" {
  description = "Zone desired to be created"
  type = string
}

variable "route53_records" {
  description = "A list of configmaps with the records that shold be created"
  type = list(object({
    name = string,
    type = string,
    ttl = number,
    records = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Mapping with tags to attach to zone"
  type = map(string)
  default = {}
}

variable "create" {
  description = "Flag to enable or disable resources creation"
  type        = bool
  default     = true
}