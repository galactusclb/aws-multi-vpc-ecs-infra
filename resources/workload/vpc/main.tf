resource "aws_vpc" "workload" {
  cidr_block = var.cidr_block

  tags = {
    Name = "vpc-workload"
  }
}

resource "aws_subnet" "this" {
  for_each = var.private_subnets

  vpc_id     = aws_vpc.workload.id
  cidr_block = each.value

  availability_zone = strcontains(each.key, "2") ? var.availability_zones[1] : var.availability_zones[0]

  tags = {
    Name : "subnet-private-${each.key}"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.workload.id

  tags = {
    Name : "rt-workload"
  }
}

resource "aws_route_table_association" "this" {
  for_each       = aws_subnet.this
  route_table_id = aws_route_table.this.id

  subnet_id = each.value.id
}

resource "aws_route" "workload_default_to_tgw" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.tgw-id
}