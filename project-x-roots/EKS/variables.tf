# VPC Vars
########################################
variable "region" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "vpc_tenancy" {
  type = string
}

variable "environment" {
  type = string
}

variable "destination_cidr" {
  type = string
}

variable "nat_connectivity_type" {
  type = string
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
}

variable "public_subnet_azs" {
  type = list(string)
}

variable "map_public_ip_on_launch" {
  type = bool
}

variable "private_subnet_cidr_blocks" {
  type = list(string)
}

variable "private_subnet_azs" {
  type = list(string)
}



# EKS Vars
########################################

# Cluster
variable "cluster_name" {
  type = string
}

variable "eks_version" {
  type = number
}


variable "control_plane_role_policy_arns" {
  type = list(string)
}

variable "ebs_csi_role_policy_arns" {
  type = list(string)
}


# Worker Nodes

variable "ebs_volume_size" {
  type = number
}

variable "volume_type" {
  type = string
}

# variable "image_id" {
#   type = string
# }

variable "instance_type" {
  type = string
}

variable "other_instance_types" {
  type        = list(any)
  description = "Additional Instance types for the Autoscaling Group"
}

variable "node_asg_min_size" {
  type = number
}

variable "node_asg_max_size" {
  type = number
}

variable "node_asg_desired_size" {
  type = number
}

variable "spot_max_price" {
  type = number
}

variable "on_demand_base_capacity" {
  type = number
}

variable "on_demand_percentage_above_base_capacity" {
  type = number
}

variable "workers_policy_arns" {
  type = list(string)
}

variable "devops_access_role_arn" {
  type        = string
  description = "DevOps Team Access Role to the Cluster"
}