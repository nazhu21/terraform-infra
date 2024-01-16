
########### Control Plane Outputs #############

output "cluster_arn" {
  value = aws_eks_cluster.control_plane.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.control_plane.endpoint
}

output "cluster_role_arn" {
  value = aws_iam_role.control_plane_iam_role.arn
}

output "control_plane_sg_id" {
  value = aws_security_group.control_plane_sg.id
}

output "control_plane_sg_arn" {
  value = aws_security_group.control_plane_sg.arn
}

output "ebs_csi_iam_role_arn" {
  value = aws_iam_role.ebs_csi_iam_role.arn
}


######### Worker Nodes Outputs #############

output "node_autoscaling_group_id" {
  value = aws_autoscaling_group.node_group.id
}

output "node_autoscaling_group_arn" {
  value = aws_autoscaling_group.node_group.arn
}

output "node_security_group_id" {
  value = aws_security_group.node_security_group.id
}

output "node_security_group_arn" {
  value = aws_security_group.node_security_group.arn
}

output "node_group_role_arn" {
  value = aws_iam_role.workers_iam_role.arn
}

output "node_group_role_name" {
  value = aws_iam_role.workers_iam_role.name
}

output "cluster_name" {
  value = aws_eks_cluster.control_plane.name
}
