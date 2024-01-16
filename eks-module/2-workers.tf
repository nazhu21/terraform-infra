################################################################################
######################## Cluster Worker Nodes ##################################
################################################################################

################################################################################
# Launch Template
################################################################################

### Worker Node AMI
data "aws_ssm_parameter" "selected_eks_optimized_ami" {

  name = "/aws/service/eks/optimized-ami/${var.eks_version}/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "node_group_lt" {
  name       = "${var.cluster_name}-launchTemplate"
  depends_on = [aws_iam_instance_profile.workers_instance_profile]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.ebs_volume_size
      volume_type           = var.volume_type
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.workers_instance_profile.name
  }

  image_id      = data.aws_ssm_parameter.selected_eks_optimized_ami.value
  instance_type = var.instance_type

  network_interfaces {
    device_index                = 0
    security_groups             = [aws_security_group.node_security_group.id]
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name              = "${var.cluster_name}-worker-nodes"
      KubernetesCluster = var.cluster_name
    }
  }

  user_data = base64encode(
    <<-EOT
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${var.cluster_name}
    EOT
  )
}


################################################################################
# Auto Scaling Group (Self Managed Node Group)
################################################################################

resource "aws_autoscaling_group" "node_group" {

  name                = "${var.cluster_name}-worker-asg"
  vpc_zone_identifier = var.worker_subnet_ids
  min_size            = var.node_asg_min_size
  max_size            = var.node_asg_max_size
  desired_capacity    = var.node_asg_desired_size

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_name = aws_launch_template.node_group_lt.name
        version              = aws_launch_template.node_group_lt.latest_version
      }

      override {
        instance_type = var.other_instance_types[0]
      }

      override {
        instance_type = var.other_instance_types[1]
      }

      override {
        instance_type = var.other_instance_types[2]
      }
    }

    instances_distribution {
      spot_max_price                           = var.spot_max_price
      on_demand_base_capacity                  = var.on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
      spot_allocation_strategy                 = "lowest-price"
    }
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${var.cluster_name}-workerNodes"
  }

  tag {
    key                 = "k8s.io/cluster/${var.cluster_name}"
    propagate_at_launch = true
    value               = "owned"
  }

  tag {
    key                 = "aws:ec2launchtemplate:id"
    propagate_at_launch = true
    value               = aws_launch_template.node_group_lt.id
  }

  tag {
    key                 = "aws:ec2launchtemplate:version"
    propagate_at_launch = true
    value               = aws_launch_template.node_group_lt.latest_version
  }

  tag {
    key                 = "aws:autoscaling:groupName"
    propagate_at_launch = true
    value               = "${var.cluster_name}-worker-asg"
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
    propagate_at_launch = true
    value               = "owned"
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    propagate_at_launch = true
    value               = "true"
  }

}


################################################################################
# Security Group
################################################################################
resource "aws_security_group" "node_security_group" {
  name   = "${var.cluster_name}-workerNodes-SG"
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.control_plane_sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.control_plane_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-workerNodes-SG"
  }
}


################################################################################
# IAM Role and InstanceProfile for NodeGroup
################################################################################

data "aws_iam_policy_document" "workers_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "workers_iam_role" {
  name               = "${var.cluster_name}-workerNodesRole"
  assume_role_policy = data.aws_iam_policy_document.workers_assume_role.json
}

resource "aws_iam_instance_profile" "workers_instance_profile" {
  name = "${var.cluster_name}-workerNodesIntanceProfile"
  role = aws_iam_role.workers_iam_role.name
}

resource "aws_iam_role_policy_attachment" "workers_attached_policies" {
  for_each   = toset(var.workers_policy_arns)
  role       = aws_iam_role.workers_iam_role.name
  policy_arn = each.value
}
