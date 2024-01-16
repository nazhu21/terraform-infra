
########################################
# VPC Vars
########################################

variable "cidr_block" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "vpc_tenancy" {
  type    = string
  default = "default"
}

variable "vpc_name" {
  type        = string
  description = "vpc name tag"
  default     = "terraformVPC"
}

variable "environment" {
  type        = string
  description = ""
  default     = "terraformCREATE"
}

########################################
# Route Table Vars
########################################

variable "destination_cidr" {
  type        = string
  description = "destination cidr block"
  default     = "0.0.0.0/0"
}

variable "nat_connectivity_type" {
  type    = string
  default = "public"
}

########################################
# Subnet Vars
########################################

variable "public_subnet_cidr_blocks" {
  description = "A list of CIDR blocks for subnets."
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
}

variable "public_subnet_azs" {
  description = "A list of azs for subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "map_public_ip_on_launch" {
  description = "bool"
  type        = bool
  default     = true
}

variable "private_subnet_cidr_blocks" {
  description = "A list of CIDR blocks for subnets."
  type        = list(string)
  default     = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
}

variable "private_subnet_azs" {
  description = "A list of azs for subnets."
  type        = list(string)
  default     = ["us-east-1d", "us-east-1e", "us-east-1f"]
}