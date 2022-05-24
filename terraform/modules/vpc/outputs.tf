output "vpc_id" {
  value = aws_vpc.tf_vpc.id
}

output "public_subnets_ids" {
  value = values(aws_subnet.public)[*].id
}
output "private_subnets_ids" {
  value = values(aws_subnet.private)[*].id
}
