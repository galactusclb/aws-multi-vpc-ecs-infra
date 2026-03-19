resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  
  tags = {
    Name = "vpc-workload"
  }
}

resource "aws_subnet" "this" {
  for_each = var.private_subnets

  vpc_id = aws_vpc.this.id
  cidr_block = each.value
  availability_zone = var.availability_zone

  tags = {
    Name: "subnet-private-${each.key}"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  # ToDo Need to add TGW route
  # route = {
  # }

  tags = {
    Name: "rt-workload"
  }
}

resource "aws_route_table_association" "this" {
  for_each = aws_subnet.this
  route_table_id = aws_route_table.this.id

  subnet_id = each.value.id
}