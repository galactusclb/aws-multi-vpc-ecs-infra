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

  # ToDo Need to add TGW route
  # route {
  #   cidr_block  = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.igw.id
  # }

  tags = {
    Name : "rt-workload"
  }
}

resource "aws_route_table_association" "this" {
  for_each       = aws_subnet.this
  route_table_id = aws_route_table.this.id

  subnet_id = each.value.id
}

resource "aws_route" "route-to-tgw" {
  route_table_id = aws_route_table.this.id

  destination_cidr_block = var.internet_vpc_cidr
  transit_gateway_id = var.transit_gateway_id
}

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.workload.id

#   tags = {
#     Name = "workload-igw"
#   }
# }