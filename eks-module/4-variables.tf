# Cluster
variable "cluster_name" {
  type    = string
  #default = "terraformCluster"
}

variable "eks_version" {
  type    = number
  #default = 1.27
}

variable "control_plane_subnet_ids" {
  type    = list(string)
  #default = ["subnet-07fda1ed4ddd5a150", "subnet-0817e17656b15c857", "subnet-0ace0b2cb52d1ef51"]
}

variable "vpc_id" {
  type    = string
  #default = "vpc-0ffc80482aea74db8"
}

variable "control_plane_role_policy_arns" {
  type = list(string)
  # default = [
  #   "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  #   "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
  #   "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  # ]
}

variable "ebs_csi_role_policy_arns" {
  type    = list(string)
  #default = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
}



################### Cluster Worker Nodes Variables ###############

variable "ebs_volume_size" {
  type    = number
  #default = 8
}

variable "volume_type" {
  type    = string
  #default = "gp2"
}

variable "image_id" {
  type    = string
  #default = "ami-05442bc7f19efb62e"
}

variable "instance_type" {
  type    = string
  #default = "t3.medium"
}

variable "other_instance_types" {
  type        = list(any)
  #default     = ["t2.medium", "t3a.medium", "a1.large"]
  description = "Additional Instance types for the Autoscaling Group"
}

variable "worker_subnet_ids" {
  type    = list(string)
  #default = [""]
}

variable "node_asg_min_size" {
  type    = number
  #default = 1
}

variable "node_asg_max_size" {
  type    = number
 # default = 5
}

variable "node_asg_desired_size" {
  type    = number
 # default = 2
}

variable "spot_max_price" {
  type    = number
  #default = 0.0464
}

variable "on_demand_base_capacity" {
  type    = number
 # default = 0
}

variable "on_demand_percentage_above_base_capacity" {
  type    = number
 # default = 50
}

variable "workers_policy_arns" {
  type = list(string)
  # default = [
  #   "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  #   "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  #   "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  # ]
}

variable "devops_access_role_arn" {
  type = string
  # default = "arn:aws:iam::383585068161:role/OrganizationAccountAccessRole"
  description = "DevOps Team Access Role to the Cluster"
}