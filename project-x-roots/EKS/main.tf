
# Creating VPC for EKS
module "vpc" {
  source = "github.com/nazhu21/terraform-infra/vpc-module"
  #source = "../../vpc-module"

  cidr_block  = var.cidr_block
  vpc_name    = "${var.cluster_name}-vpc"
  environment = var.environment

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  vpc_tenancy          = var.vpc_tenancy

  destination_cidr      = var.destination_cidr
  nat_connectivity_type = var.nat_connectivity_type

  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  public_subnet_azs         = var.public_subnet_azs
  map_public_ip_on_launch   = var.map_public_ip_on_launch

  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  private_subnet_azs         = var.private_subnet_azs

}

# Creating EKS with self-managed nodes
module "eks" {
  source = "github.com/nazhu21/terraform-infra/eks-module"
  #source = "../../eks-module"

  cluster_name                   = var.cluster_name
  eks_version                    = var.eks_version
  vpc_id                         = module.vpc.vpc_id
  control_plane_subnet_ids       = [module.vpc.public_subnet_ids[0], module.vpc.public_subnet_ids[1], module.vpc.public_subnet_ids[2]]
  control_plane_role_policy_arns = var.control_plane_role_policy_arns
  ebs_csi_role_policy_arns       = var.ebs_csi_role_policy_arns

  ebs_volume_size                          = var.ebs_volume_size
  volume_type                              = var.volume_type
  instance_type                            = var.instance_type
  other_instance_types                     = var.other_instance_types
  worker_subnet_ids                        = [module.vpc.public_subnet_ids[0], module.vpc.public_subnet_ids[1], module.vpc.public_subnet_ids[2]]
  node_asg_min_size                        = var.node_asg_min_size
  node_asg_max_size                        = var.node_asg_max_size
  node_asg_desired_size                    = var.node_asg_desired_size
  spot_max_price                           = var.spot_max_price
  on_demand_base_capacity                  = var.on_demand_base_capacity
  on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
  workers_policy_arns                      = var.workers_policy_arns
  devops_access_role_arn                   = var.devops_access_role_arn
}
