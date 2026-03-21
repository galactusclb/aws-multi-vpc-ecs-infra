resource "aws_vpc" "internet" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-internet"
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets
  vpc_id = aws_vpc.internet.id

  availability_zone = strcontains(each.key, "2") ? var.availability_zones[1] :  var.availability_zones[0]
  cidr_block = each.value

  tags = {
    Name = "subnet-public-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets
  vpc_id = aws_vpc.internet.id

  availability_zone = strcontains(each.key, "2") ? var.availability_zones[1] :  var.availability_zones[0]
  cidr_block = each.value

  tags = {
    Name = "subnet-private-${each.key}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.internet.id

  tags = {
    Name = "internet-igw"
  }
}

# ToDo Need to create separate rt for tgw subnet
resource "aws_route_table" "internet-rt-public" {
  vpc_id = aws_vpc.internet.id

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  route {
    cidr_block = var.workload_vpc_cidr
    transit_gateway_id = var.transit_gateway_id
  }
 
   tags = {
    Name = "internet-rt-public"
  }
}

resource "aws_route_table_association" "public-rt-association" {
  for_each = aws_subnet.public

  route_table_id = aws_route_table.internet-rt-public.id
  subnet_id = each.value.id
}


# private route
resource "aws_eip" "nat" {
  domain = "vpc"

  depends_on = [ aws_internet_gateway.this ]
}

resource "aws_nat_gateway" "this" {
  subnet_id = aws_subnet.private["gateway3"].id
  allocation_id = aws_eip.nat.id

  depends_on = [ aws_internet_gateway.this ]

  tags = {
    Name = "internet-NAT-GW" 
  }
}
resource "aws_route_table" "internet-rt-private" {
  vpc_id = aws_vpc.internet.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  route {
    transit_gateway_id = var.transit_gateway_id
    cidr_block = var.workload_vpc_cidr
  }

  tags = {
    Name: "internet-rt-private"
  }
}
 
resource "aws_route_table_association" "private-rt-association" {
  for_each = aws_subnet.private

  route_table_id = aws_route_table.internet-rt-private.id
  subnet_id = each.value.id
}