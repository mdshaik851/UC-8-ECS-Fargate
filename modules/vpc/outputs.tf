output "security_group_ecs_farget" {
  value = aws_security_group.ecs_farget.id
}

output "security_group_alb" {
  value = aws_security_group.alb.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}

output "vpc_id_details" {
  value = aws_vpc.demo-vpc-uc8.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}