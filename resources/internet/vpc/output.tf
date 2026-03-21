output "vpc_id" {
  value = aws_vpc.internet.id
}

output "vpc_cidr" {
  value = aws_vpc.internet.cidr_block
}

output "public_subnet_ids" {
  value = {
    for k,v in aws_subnet.public : k => v.id
  }
}

output "private_subnet_ids" {
  value = {
    for k,v in aws_subnet.private : k => v.id
  }
}