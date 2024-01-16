region = "us-east-1"

#### VPC Vars
cidr_block            = "10.0.0.0/16"
vpc_name              = "" #ClusterNameVariablePassedtoVPCName
enable_dns_support    = true
enable_dns_hostnames  = true
vpc_tenancy           = "default"
environment           = "dev"
destination_cidr      = "0.0.0.0/0"
nat_connectivity_type = "public"

public_subnet_cidr_blocks = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
public_subnet_azs         = ["us-east-1a", "us-east-1b", "us-east-1c"]
map_public_ip_on_launch   = true

private_subnet_cidr_blocks = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
private_subnet_azs         = ["us-east-1d", "us-east-1e", "us-east-1f"]

#### EKS Vars
cluster_name = "eks-tf-dev"
eks_version  = 1.27
control_plane_role_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
  "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
]
ebs_csi_role_policy_arns = [
  "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
]

ebs_volume_size = 8
volume_type     = "gp2"
#aws ssm get-parameter --name /aws/service/eks/optimized-ami/1.27/amazon-linux-2/recommended/image_id --region us-east-1 --query "Parameter.Value" --output text
image_id                                 = "ami-05442bc7f19efb62e"
instance_type                            = "t2.micro"
node_asg_min_size                        = 1
node_asg_max_size                        = 4
node_asg_desired_size                    = 2
spot_max_price                           = 0.0464
on_demand_base_capacity                  = 0
on_demand_percentage_above_base_capacity = 50
workers_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
]