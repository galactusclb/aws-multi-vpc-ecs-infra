resource "aws_vpc" "internet" {
  cidr_block = var.cidr_block

  tags = {
    Name = "vpc-internet"
  }
}

resource "aws_subnet" "this" {
  for_each = var.subnets
  vpc_id = aws_vpc.internet.id

  availability_zone = strcontains(each.key, "2") ? var.availability_zones[1] :  var.availability_zones[0]
  cidr_block = each.value

  tags = {
    Name = "subnet-public-${each.key}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.internet.id

  tags = {
    Name = "internet-igw"
  }
}

# ToDo Need to create separate rt for tgw subnet
resource "aws_route_table" "rt-internet" {
  vpc_id = aws_vpc.internet.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name: "rt-internet"
  }
}

resource "aws_route_table_association" "this" {
  for_each = aws_subnet.this

  route_table_id = aws_route_table.rt-internet.id
  subnet_id = each.value.id
}