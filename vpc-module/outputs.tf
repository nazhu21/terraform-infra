########################################
# VPC Outputs
########################################

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

########################################
# Subnet Outputs (id and arn)
########################################


output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "public_subnet_arns" {
  value = aws_subnet.public_subnets[*].arn
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "private_subnet_arns" {
  value = aws_subnet.private_subnets[*].arn
}

########################################
# Elastic IP Outputs (public ip and dns)
########################################

output "eip_public_ip" {
  value = aws_eip.elastic_ip.public_ip
}
output "eip_public_dns" {
  value = aws_eip.elastic_ip.public_dns
}

