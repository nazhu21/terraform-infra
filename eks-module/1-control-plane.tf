################################################################################
######################### Cluster Control Plane ################################
################################################################################

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  eks_cluster_endpoint = aws_eks_cluster.control_plane.endpoint
  eks_oidc             = regex("https://([^.]+)\\..*", local.eks_cluster_endpoint)[0]
}

################################################################################
# EKS Cluster
################################################################################

resource "aws_eks_cluster" "control_plane" {
  name     = var.cluster_name
  role_arn = aws_iam_role.control_plane_iam_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids         = var.control_plane_subnet_ids
    security_group_ids = [aws_security_group.control_plane_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.control_plane_attached_policies
  ]
}

################################################################################
# IAM Role for EKS
################################################################################

data "aws_iam_policy_document" "control_plane_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "control_plane_iam_role" {
  name               = "${var.cluster_name}-serviceRoleForEKS"
  assume_role_policy = data.aws_iam_policy_document.control_plane_assume_role.json
}

resource "aws_iam_role_policy_attachment" "control_plane_attached_policies" {
  for_each   = toset(var.control_plane_role_policy_arns)
  role       = aws_iam_role.control_plane_iam_role.name
  policy_arn = each.value
}

################################################################################
# EKS Security Group
################################################################################

resource "aws_security_group" "control_plane_sg" {
  name        = "${var.cluster_name}-ControlPlane-SG"
  description = "Control Plane Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-ControlPlane-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "IngressControlPlane443" {
  depends_on = [ aws_security_group.node_security_group ]
  
  security_group_id = aws_security_group.control_plane_sg.id

  from_port                    = 443
  ip_protocol                  = "tcp"
  to_port                      = 443
  referenced_security_group_id = aws_security_group.node_security_group.id
}


################################################################################
# KMS Key (Need it?)
################################################################################



################################################################################
# EKS Add-ons
################################################################################


resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.control_plane.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.control_plane.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.control_plane.name
  addon_name   = "kube-proxy"
}

##########################
# EBS CSI Driver IAM Role
data "aws_iam_policy_document" "ebs_csi_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/${local.eks_oidc}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/${local.eks_oidc}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/${local.eks_oidc}"]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "ebs_csi_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role_policy.json
  name               = "${var.cluster_name}-EbsCsiDriverRole"
}

resource "aws_iam_role_policy_attachment" "ebs_csi_role_attached_policies" {
  for_each   = toset(var.ebs_csi_role_policy_arns)
  role       = aws_iam_role.ebs_csi_iam_role.name
  policy_arn = each.value
}
#######################
# Adding EBS CSI Driver
resource "aws_eks_addon" "ebs_csi_driver" {
  depends_on               = [aws_iam_role.ebs_csi_iam_role]
  cluster_name             = aws_eks_cluster.control_plane.name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi_iam_role.arn
}


#############################################
################ Local Execs ################
#############################################

resource "null_resource" "local_execs" {

  depends_on = [aws_eks_cluster.control_plane]

  ### OIDC
  provisioner "local-exec" {
    command = "eksctl utils associate-iam-oidc-provider --cluster ${var.cluster_name} --approve --region ${data.aws_region.current.name}"
  }

  # update kube-config
  provisioner "local-exec" {
    command = "aws eks --region ${data.aws_region.current.name} update-kubeconfig --name ${var.cluster_name}"
  }

}

