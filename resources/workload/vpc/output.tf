output "vpc_id" {
  value = aws_vpc.workload.id
}

output "vpc_cidr" {
  value = aws_vpc.workload.cidr_block
}

output "private_subnet_ids" {
  value = {
    for k, v in aws_subnet.this : k => v.id
  }
}

output "route_table_id" {
  value = aws_route_table.this.id
}
